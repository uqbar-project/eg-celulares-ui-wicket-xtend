package uqbar.celulares.ui.wicket;

import java.util.List;

import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Button;
import org.apache.wicket.markup.html.form.CheckBox;
import org.apache.wicket.markup.html.form.ChoiceRenderer;
import org.apache.wicket.markup.html.form.DropDownChoice;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.form.TextField;
import org.apache.wicket.markup.html.panel.FeedbackPanel;
import org.apache.wicket.model.CompoundPropertyModel;
import org.apache.wicket.model.LoadableDetachableModel;
import org.uqbar.commons.model.UserException;
import org.uqbar.commons.utils.ApplicationContext;

import uqbar.celulares.domain.Celular;
import uqbar.celulares.domain.HomeCelulares;
import uqbar.celulares.domain.HomeModelos;
import uqbar.celulares.domain.Modelo;

/**
 * Pagina de edicion de un celular.
 */
public class EditarCelularPage extends WebPage {
	private static final long serialVersionUID = 1L;
	private final Celular celular;
	private final boolean alta;
	private final BusquedaCelularesPage mainPage; 

	public EditarCelularPage(Celular celularAEditar, BusquedaCelularesPage mainPage) {
		this.mainPage = mainPage;
		
		this.alta = celularAEditar.isNew();
		this.celular = celularAEditar;
		this.add(new Label("titulo", this.alta ? "Nuevo Celular" : "Editar Datos del Celular"));
		
		Form<Celular> buscarForm = new Form<Celular>("nuevoCelularForm", new CompoundPropertyModel<Celular>(this.celular));
		this.agregarCamposEdicion(buscarForm);
		this.agregarAcciones(buscarForm);
		this.add(buscarForm);
	}

	private void agregarAcciones(Form<Celular> parent) {
		parent.add(new Button("aceptar") {
			@Override
			public void onSubmit() {
				try {
					EditarCelularPage.this.celular.validar();
					HomeCelulares homeCelulares = getHomeCelulares();
					if (EditarCelularPage.this.alta) {
						homeCelulares.create(EditarCelularPage.this.celular);
					} else {
						homeCelulares.delete(EditarCelularPage.this.celular);
						homeCelulares.create(EditarCelularPage.this.celular);
					}
					volver();
				} catch (UserException e) {
					info(e.getMessage());
				} catch (Exception e) {
					error("Ocurrió un error al procesar el pedido del celular. Consulte al administrador del sistema");
				}
			}
		});
		parent.add(new Button("cancelar") {
			@Override
			public void onSubmit() {
				volver();
			}

		});
	}

	protected void volver() {
		// antes generaba una nueva instancia de la página que busca celulares
		// this.setResponsePage(BusquedaCelularesPage.class);
		// ahora recibimos una referencia a la mainPage
		// pero sabemos que no es cualquier página, entonces le pedimos que refresque
		// la búsqueda para que la grilla se vea actualizada
		// a futuro podríamos evitar que la página de edición conozca tanto sobre 
		// la vista "madre" y el mensaje sea simplemente "updateView", algo más
		// abstracto que cada vista de nuestra aplicación sepa hacer
		mainPage.buscarCelulares();
		this.setResponsePage(mainPage);
	}

	private void agregarCamposEdicion(Form<Celular> parent) {
		parent.add(new TextField<String>("numero"));
		parent.add(new TextField<String>("nombre"));
		parent.add(new DropDownChoice<Modelo>("modeloCelular", crearModeloListaModelosCelulares(), createModeloChoiceRenderer()));
		parent.add(new CheckBox("recibeResumenCuenta"));
		parent.add(new FeedbackPanel("feedbackPanel"));
	}

	protected ChoiceRenderer<Modelo> createModeloChoiceRenderer() {
		return new ChoiceRenderer<Modelo>() {
			@Override
			public Object getDisplayValue(Modelo object) {
				return object.getDescripcion();
			}
		};
	}

	protected LoadableDetachableModel<List<Modelo>> crearModeloListaModelosCelulares() {
		return new LoadableDetachableModel<List<Modelo>>() {
			@Override
			protected List<Modelo> load() {
				return getHomeModelos().getModelos();
			}
		};
	}
	
	protected HomeCelulares getHomeCelulares() {
		return ApplicationContext.getInstance().getSingleton(Celular.class);
	}
	
	protected HomeModelos getHomeModelos() {
		return ApplicationContext.getInstance().getSingleton(Modelo.class);
	}

}
