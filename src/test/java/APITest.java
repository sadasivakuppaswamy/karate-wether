import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.masterthought.cucumber.presentation.PresentationMode;
import org.apache.commons.io.FileUtils;
import org.junit.*;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class APITest {
    Results results = null;

    @BeforeClass
    public static void beforeClass() throws Exception {
        TestBase.beforeClass();
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: Before Class");
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }

    @AfterClass
    public static void afterClass() throws Exception {
        TestBase.afterClass();
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: After Class");
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }

    @Test
    public void testParallel() {
        String parallel = System.getProperty("parallel");
        int parallelCount = (null == parallel) ? 30 : Integer.parseInt(parallel);
        System.out.println("Parallel count: " + parallelCount);

        String customTagsToRun = System.getProperty("tag");
        String[] str2 = customTagsToRun.replace("[","").replace("]","").trim().split(",");
        List<String> customTags = Arrays.asList(str2);
        List<String> strings = new ArrayList<>();
        strings.add("~@template");
        strings.add("@wetherbypostal");
        //strings.addAll(customTags);
        if ((null != customTagsToRun) && (!customTagsToRun.trim().isEmpty())) { strings.addAll(customTags); }
        System.out.println("Run tests with tag - " + strings);
        results = Runner.path("classpath:features").outputCucumberJson(true).tags(strings).parallel(5);
              //  .outputCucumberJson(true).reportDir("reports/surefire-reports").parallel(parallelCount);
    }

    @After
    public void afterMethod() {
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: After Method");

        String reportLocation = generateReport(results.getReportDir());
        System.out.println("Reports available here: " + reportLocation);
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        Assert.assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void main(String[] args) {
        String reportLocation = generateReport("reports/surefire-reports");
        System.out.println("Reports available here: " + reportLocation);
    }

    private static String generateReport(String karateOutputPath) {
        System.out.println("================================");
        System.out.println("Generating reports");
        System.out.println("================================");
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        System.out.println("Number of json files found: " + jsonFiles.size());
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("reports"), "karate-sample");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
        return config.getReportDirectory().getAbsolutePath() +"/cucumber-html-reports/overview-features.html";
    }
}
