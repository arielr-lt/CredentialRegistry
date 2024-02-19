There is a set of jobs that are executed via Cloud66 async jobs section:

1. Title: "Backup dump to archive.org"  
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `dumps:backup`  
  c. **server:** Narwhal  
  d. **Job description/purpose:** _Backups a transaction dump file to a remote provider. Accepts an argument to specify the dump date (defaults to yesterday)_

3. Title: "Update JSON contexts"  
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `json_contexts:update`  
  c. **server:** N/A  
  d. **Job description/purpose:** _Updates the JSON context specs used for indexing envelope resources_

5. Title: "Purge Envelopes"  - Currently disabled, no server allocated
  a. **schedule:** 01:00 AM UTC  
  b. **rake task:** `envelopes:purge`  
  c. **server:** Narwhal


7. Title: "Reindex All"    - Currently disabled, no server allocated
  a. **schedule:** "On demand"  
  b. **rake task:** `search:reindex`  
  c. **server:** N/A  

