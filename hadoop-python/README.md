# hadoop to run python scripy in mapreduce way

## how to run

### install hadoop
first install hadoop

``` bash
tar -zxvf hadoop-3.0.0-alpha1.tar.gz ~/hadoop
export PATH="$HOME/hadoop/bin:$PATH"
```

### run scripy

``` bash
# A
hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'TitleCountMapper.py stopwords.txt delimiters.txt' -file TitleCountMapper.py -reducer 'TitleCountReducer.py' -file TitleCountReducer.py -input dataset/titles/ -output ./preA-output_Python

hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'TopTitlesMapper.py' -file TopTitlesMapper.py -reducer 'TopTitlesReducer.py' -file TopTitlesReducer.py -input ./preA-output_Python/ -output ./A-output_Python

# B
hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'TopTitleStatisticsMapper.py' -file TopTitleStatisticsMapper.py -reducer 'TopTitleStatisticsReducer.py' -file TopTitleStatis

# C
hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'OrphanPagesMapper.py' -file OrphanPagesMapper.py -reducer 'OrphanPagesReducer.py' -file OrphanPagesReducer.py -input dataset/links/ -output ./C-output_Python

# D
hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'LinkCountMapper.py' -file LinkCountMapper.py -reducer 'LinkCountReducer.py' -file LinkCountReducer.py -input dataset/links/ -output ./linkCount-output_Python

hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'TopPopularLinksMapper.py' -file TopPopularLinksMapper.py -reducer 'TopPopularLinksReducer.py' -file TopPopularLinksReducer.py -input ./linkCount-output_Python -output ./D-output_Python

# E
hadoop jar ~/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.0.0.jar -mapper 'PopularityLeagueMapper.py dataset/league.txt' -file PopularityLeagueMapper.py -reducer 'PopularityLeagueReducer.py' -file PopularityLeagueReducer.py -input ./linkCount-output_Python -output ./E-output_Python
```
