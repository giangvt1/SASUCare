package Service;

import dao.AppointmentDBContext;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppointmentStatusUpdater implements ServletContextListener {
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private final AppointmentDBContext appointmentDB = new AppointmentDBContext();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler.scheduleAtFixedRate(() -> {
            try {
                System.out.println("Running expired appointment check...");
                appointmentDB.cancelExpiredAppointments(); // Call your method to update expired appointments
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 5, TimeUnit.MINUTES); // Runs every 5 minutes
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        scheduler.shutdownNow(); // Stop the scheduler when server shuts down
    }
}
