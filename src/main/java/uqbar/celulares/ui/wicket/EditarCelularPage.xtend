package uqbar.celulares.ui.wicket

import org.apache.wicket.markup.html.WebPage
import org.apache.wicket.markup.html.basic.Label
import org.apache.wicket.markup.html.form.CheckBox
import org.apache.wicket.markup.html.form.DropDownChoice
import org.apache.wicket.markup.html.form.Form
import org.apache.wicket.markup.html.form.TextField
import org.apache.wicket.markup.html.panel.FeedbackPanel
import org.uqbar.commons.model.UserException
import org.uqbar.wicket.xtend.WicketExtensionFactoryMethods
import org.uqbar.wicket.xtend.XButton
import uqbar.celulares.domain.Celular
import uqbar.celulares.domain.Modelo

/**
 * 
 */
class EditarCelularPage extends WebPage {
	extension WicketExtensionFactoryMethods = new WicketExtensionFactoryMethods
	private final Celular celular
	private final boolean alta
	private final BusquedaCelularesPage mainPage
	
	new(Celular celularAEditar, BusquedaCelularesPage mainPage) {
		this.mainPage = mainPage
		
		this.alta = celularAEditar.isNew()
		this.celular = celularAEditar
		this.addChild(new Label("titulo", if (this.alta) "Nuevo Celular" else "Editar Datos del Celular"))
		
		val buscarForm = new Form<Celular>("nuevoCelularForm", this.celular.asCompoundModel)
		this.agregarCamposEdicion(buscarForm)
		this.agregarAcciones(buscarForm)
		this.addChild(buscarForm)
	}
	
	def void agregarAcciones(Form<Celular> parent) {
		parent.addChild(new XButton("aceptar") => [
			onClick = [|
				try {
					celular.validar()
					if (alta) {
						Celular.home.create(celular)
					} else {
						Celular.home.delete(celular)
						Celular.home.create(celular)
					}
					volver()
				} catch (UserException e) {
					info(e.getMessage())
				} catch (RuntimeException e) {
					error("Ocurrió un error al procesar el pedido del celular. Consulte al administrador del sistema")
				}
			]				
		])
		parent.addChild(new XButton("cancelar") => [
			onClick = [| volver ]
		])
	}
	
	def volver() {
		mainPage.buscarCelulares()
		responsePage = mainPage
	}

	def agregarCamposEdicion(Form<Celular> parent) {
		parent.addChild(new TextField<String>("numero"))
		parent.addChild(new TextField<String>("nombre"))
		parent.addChild(new DropDownChoice<Modelo>("modeloCelular") => [
			choices = loadableModel([| Modelo.home.allInstances ])
			choiceRenderer = choiceRenderer([Modelo m| m.descripcion ])
		]) 
		parent.addChild(new CheckBox("recibeResumenCuenta"))
		parent.addChild(new FeedbackPanel("feedbackPanel"))
	}

}