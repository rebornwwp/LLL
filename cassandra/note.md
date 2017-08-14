
# 错误

```
ERROR 16:12:34 Exiting due to error while processing commit log during initialization. org.apache.cassandra.db.commitlog.CommitLogReplayer$CommitLogReplayException: Could not read commit log descriptor in file ./../data/commitlog/CommitLog-5-1446227619917.log

解决方法：
Please delete Data/commitlogs to proceed in such cases. but this method may remove your sensitive data.
```

# update set of userdefinedtype
```
 UPDATE item SET historys = historys + {{uuid:55f6d072-046d-42b6-ae69-8550ca966229, created_time:1991-10-15 02:59:04.00, content:'hello world'}} WHERE id=014a4102-5d4a-4bef-862f-ae08e7b2fb55;
```
