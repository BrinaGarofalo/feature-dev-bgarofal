import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;
import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import static org.junit.jupiter.api.Assertions.assertEquals;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:karate-test.feature")
                .outputCucumberJson(true)
                .relativeTo(getClass());
    }
    
    @Test
    void testParallel() {
        Results results = Runner.path("classpath:karate-test.feature")
                .outputCucumberJson(true)
                .parallel(1);
        generateReport(results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
    
    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = org.apache.commons.io.FileUtils.listFiles(
                new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(
                new File("build/karate-reports"), "marvel-api-tests");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
