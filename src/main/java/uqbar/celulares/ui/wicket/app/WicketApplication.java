package uqbar.celulares.ui.wicket.app;

import org.apache.wicket.protocol.http.WebApplication;
import org.uqbar.commons.utils.ApplicationContext;

import uqbar.celulares.domain.Celular;
import uqbar.celulares.domain.HomeCelulares;
import uqbar.celulares.domain.HomeModelos;
import uqbar.celulares.domain.Modelo;
import uqbar.celulares.ui.wicket.BusquedaCelularesPage;

/**
 * Application object for your web application. If you want to run this
 * application without deploying, run the Start class.
 * 
 * @see uqbar.celulares.ui.wicket.Start#main(String[])
 */
public class WicketApplication extends WebApplication {
	
	@Override
	protected void init() {
		super.init();
		ApplicationContext.getInstance().configureSingleton(Modelo.class, new HomeModelos());
		ApplicationContext.getInstance().configureSingleton(Celular.class, new HomeCelulares());
	}

	@Override
	public Class<BusquedaCelularesPage> getHomePage() {
		return BusquedaCelularesPage.class;
	}

}
