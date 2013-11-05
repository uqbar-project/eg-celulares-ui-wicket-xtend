package uqbar.celulares.ui.wicket.app

import org.apache.wicket.protocol.http.WebApplication
import org.uqbar.commons.utils.ApplicationContext
import uqbar.celulares.domain.Celular
import uqbar.celulares.domain.HomeCelulares
import uqbar.celulares.domain.HomeModelos
import uqbar.celulares.domain.Modelo
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