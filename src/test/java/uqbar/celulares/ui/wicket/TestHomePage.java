package uqbar.celulares.ui.wicket;

import junit.framework.TestCase;
import org.apache.wicket.util.tester.WicketTester;

import uqbar.celulares.ui.wicket.BusquedaCelularesPage;
import uqbar.celulares.ui.wicket.app.WicketApplication;


/**
 * Simple test using the WicketTester
 */
public class TestHomePage extends TestCase
{
	private WicketTester tester;

	@Override
	public void setUp()
	{
		tester = new WicketTester(new WicketApplication());
	}

	public void testRenderMyPage()
	{
		//start and render the test page
		tester.startPage(BusquedaCelularesPage.class);

		//assert rendered page class
		tester.assertRenderedPage(BusquedaCelularesPage.class);

		//assert rendered label component
		tester.assertLabel("message", "If you see this message wicket is properly configured and running");
	}
}
