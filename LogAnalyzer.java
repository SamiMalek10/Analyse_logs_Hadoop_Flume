import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

/**
 * Programme MapReduce pour analyser les logs web
 */
public class LogAnalyzer {

    // Regex pour parser les logs au format Apache Common Log
    private static final Pattern LOG_PATTERN = Pattern.compile(
            "^([\\d.]+) \\- ([\\w-]+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] \"(.+?)\" (\\d{3}) (\\d+) \"([^\"]+)\"");

    /**
     * Mapper class pour extraire les informations des logs
     */
    public static class LogMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text outputKey = new Text();

        @Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            // Ignorer les lignes vides ou les fichiers temporaires .tmp de Flume
	    if (line.trim().isEmpty() || line.contains(".tmp")) {
	        return;
	    }

            Matcher matcher = LOG_PATTERN.matcher(line);
            
            if (matcher.find()) {
                // Extraire les composants du log
                String ip = matcher.group(1);
                String user = matcher.group(2);
                String dateTime = matcher.group(3);
                String request = matcher.group(4);
                String statusCode = matcher.group(5);
                String bytes = matcher.group(6);
                String userAgent = matcher.group(7);
                
                // Analyser la requête pour obtenir la méthode HTTP et l'URL
                String[] requestParts = request.split(" ");
                if (requestParts.length >= 2) {
                    String method = requestParts[0];
                    String endpoint = requestParts[1];
                    
                    // Émettre des statistiques par endpoint
                    outputKey.set("endpoint:" + endpoint);
                    context.write(outputKey, one);
                    
                    // Émettre des statistiques par code de statut HTTP
                    outputKey.set("status:" + statusCode);
                    context.write(outputKey, one);
                    
                    // Émettre des statistiques par utilisateur
                    outputKey.set("user:" + user);
                    context.write(outputKey, one);
                    
                    // Émettre des statistiques par IP
                    outputKey.set("ip:" + ip);
                    context.write(outputKey, one);
                    
                    // Émettre des statistiques par méthode HTTP
                    outputKey.set("method:" + method);
                    context.write(outputKey, one);
                }
            }
        }
    }

    /**
     * Reducer class pour compter les occurrences
     */
    public static class LogReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        @Override
        public void reduce(Text key, Iterable<IntWritable> values, Context context)
                throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    /**
     * Méthode principale pour exécuter le job MapReduce
     */
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();
        
        if (otherArgs.length != 2) {
            System.err.println("Usage: LogAnalyzer <in> <out>");
            System.exit(2);
        }
        
        Job job = Job.getInstance(conf, "Log Analysis");
        job.setJarByClass(LogAnalyzer.class);
        job.setMapperClass(LogMapper.class);
        job.setCombinerClass(LogReducer.class);
        job.setReducerClass(LogReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        
        FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
        FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
        
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
