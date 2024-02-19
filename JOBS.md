There is a set of jobs that are executed via Cloud66 async jobs section:

1. Title: "Backup dump to archive.org"  
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `dumps:backup`  
  c. **server:** Narwhal  
  d. **Job description/purpose:** _Backups a transaction dump file to a remote provider. Accepts an argument to specify the dump date (defaults to yesterday)_  
2. Title: "Update JSON contexts"  
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `json_contexts:update`  
  c. **server:** Narwhal  
3. Title: "Purge Envelopes"  
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `json_contexts:update`  
  c. **server:** Narwhal  
4. Title: "Reindex All"  
  a. **schedule:** "On demand"  
  b. **rake task:** `search:reindex`  
  c. **server:** Narwhal  

