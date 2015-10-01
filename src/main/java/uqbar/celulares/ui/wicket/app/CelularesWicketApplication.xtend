package uqbar.celulares.ui.wicket.app

import ar.edu.celulares.domain.Celular
import ar.edu.celulares.domain.Modelo
import ar.edu.celulares.home.HomeCelulares
import ar.edu.celulares.home.HomeModelos
import org.apache.wicket.protocol.http.WebApplication
import org.uqbar.commons.utils.ApplicationContext
import uqbar.celulares.ui.wicket.BusquedaCelularesPage

/**
 * 
 */
class CelularesWicketApplication extends WebApplication {
	
	override protected init() {
		super.init()
		ApplicationContext.instance.configureSingleton(Modelo, new HomeModelos)
		ApplicationContext.instance.configureSingleton(Celular, new HomeCelulares)
	}
	
	override getHomePage() {
		return BusquedaCelularesPage
	}
	
}