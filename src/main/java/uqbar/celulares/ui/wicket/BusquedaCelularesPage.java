package uqbar.celulares.ui.wicket;

import org.apache.wicket.markup.html.WebPage;
import org.apache.wicket.markup.html.basic.Label;
import org.apache.wicket.markup.html.form.Button;
import org.apache.wicket.markup.html.form.CheckBox;
import org.apache.wicket.markup.html.form.Form;
import org.apache.wicket.markup.html.form.TextField;
import org.apache.wicket.markup.html.list.ListItem;
import org.apache.wicket.markup.html.list.PropertyListView;
import org.apache.wicket.model.CompoundPropertyModel;

import uqbar.celulares.domain.BuscadorCelular;
import uqbar.celulares.domain.Celular;

/**
 * Pagina de busqueda de la aplicacion de celulares.
 */
public class BusquedaCelularesPage extends WebPage {
	private static final long serialVersionUID = 1L;
	private final BuscadorCelular buscador;

	public BusquedaCelularesPage() {
		this.buscador = new BuscadorCelular();
		Form<BuscadorCelular> buscarForm = new Form<BuscadorCelular>("buscarCelularesForm", new CompoundPropertyModel<BuscadorCelular>(this.buscador));
		this.agregarCamposBusqueda(buscarForm);
		this.agregarAcciones(buscarForm);
		this.agregarGrillaResultados(buscarForm);
		this.add(buscarForm);
		// Al abrir el formulario disparo la búsqueda
		this.buscarCelulares();
	}

	public void buscarCelulares() {
		this.buscador.search();
	}

	private void agregarCamposBusqueda(Form<BuscadorCelular> parent) {
		parent.add(new TextField<String>("numero"));
		parent.add(new TextField<String>("nombre"));
	}

	private void agregarAcciones(Form<BuscadorCelular> parent) {
		parent.add(new Button("buscar") {
			@Override
			public void onSubmit() {
				BusquedaCelularesPage.this.buscador.search();
			}

		});
		parent.add(new Button("limpiar") {
			@Override
			public void onSubmit() {
				BusquedaCelularesPage.this.buscador.clear();
			}

		});
		parent.add(new Button("nuevo") {
			@Override
			public void onSubmit() {
				BusquedaCelularesPage.this.editar(new Celular());
			}

		});
	}

	private void agregarGrillaResultados(Form<BuscadorCelular> parent) {
		// Resultados
		parent.add(new PropertyListView<Celular>("resultados") {
			@Override
			protected void populateItem(final ListItem<Celular> item) {
				item.add(new Label("nombre"));
				item.add(new Label("numero"));
				
				item.add(new Label("modeloCelular.descripcion"));
				
				CheckBox checkResumen = new CheckBox("recibeResumenCuenta");
				// Ojo, no poner en HTML disabled=true porque no lo refresca al model después
				checkResumen.setEnabled(false);
				//
				item.add(checkResumen);
				item.add(new Button("editar") {
					@Override
					public void onSubmit() {
						Celular celular = item.getModelObject();
						BusquedaCelularesPage.this.editar(celular);
					}
				});
				item.add(new Button("eliminar") {
					@Override
					public void onSubmit() {
						BusquedaCelularesPage.this.buscador.setCelularSeleccionado(item.getModelObject());
						BusquedaCelularesPage.this.buscador.eliminarCelularSeleccionado();
					}
				});
			}

		});
	}

	protected void editar(Celular celular) {
		EditarCelularPage editar = new EditarCelularPage(celular, this);
		this.setResponsePage(editar);
	}

}