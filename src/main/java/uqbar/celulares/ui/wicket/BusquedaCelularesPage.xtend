package uqbar.celulares.ui.wicket

import org.apache.wicket.markup.html.WebPage
import org.apache.wicket.markup.html.basic.Label
import org.apache.wicket.markup.html.form.CheckBox
import org.apache.wicket.markup.html.form.Form
import org.apache.wicket.markup.html.form.TextField
import org.apache.wicket.model.CompoundPropertyModel
import org.uqbar.wicket.xtend.WicketExtensionFactoryMethods
import org.uqbar.wicket.xtend.XButton
import org.uqbar.wicket.xtend.XListView
import uqbar.celulares.domain.BuscadorCelular
import uqbar.celulares.domain.Celular

/**
 * Pagina de busqueda de la aplicacion de celulares.
 */
class BusquedaCelularesPage extends WebPage {
	extension WicketExtensionFactoryMethods = new WicketExtensionFactoryMethods
	var BuscadorCelular buscador

	new() {
		this.buscador = new BuscadorCelular()
		val Form<BuscadorCelular> buscarForm = new Form<BuscadorCelular>("buscarCelularesForm", new CompoundPropertyModel<BuscadorCelular>(this.buscador))
		this.agregarCamposBusqueda(buscarForm)
		this.agregarAcciones(buscarForm)
		this.agregarGrillaResultados(buscarForm)
		this.addChild(buscarForm)
		// Al abrir el formulario disparo la búsqueda
		this.buscarCelulares()
	}

	def buscarCelulares() {
		this.buscador.search()
	}

	def agregarCamposBusqueda(Form<BuscadorCelular> parent) {
		parent.addChild(new TextField<String>("numero"))
		parent.addChild(new TextField<String>("nombre"))
	}

	def agregarAcciones(Form<BuscadorCelular> parent) {
		val buscarButton = new XButton("buscar")
		buscarButton.onClick = [| buscador.search ]
		parent.addChild(buscarButton)
		
		parent.addChild(new XButton("limpiar")
			.onClick = [| buscador.clear ]
		)
		
		parent.addChild(new XButton("nuevo").onClick = [| editar(new Celular) ])
	}
	
	def editar(Celular celular) {
		responsePage = new EditarCelularPage(celular, this) 
	}		

	def agregarGrillaResultados(Form<BuscadorCelular> parent) {
		val listView = new XListView("resultados")
		listView.populateItem = [ item |
			item.model = item.modelObject.asCompoundModel
			item.addChild(new Label("nombre"))
			item.addChild(new Label("numero"))
			item.addChild(new Label("modeloCelular.descripcion"))
			
			val checkResumen = new CheckBox("recibeResumenCuenta")
			checkResumen.setEnabled(false)
			item.addChild(checkResumen)
			
			item.addChild(new XButton("editar").onClick = [| editar(item.modelObject) ])
			item.addChild(new XButton("eliminar")
				.onClick = [| 
					buscador.celularSeleccionado = item.modelObject
					buscador.eliminarCelularSeleccionado
				]
			)
		]
		parent.addChild(listView)
	}

}