xml.instruct!
xml.s3 {
  xml.accessKeyId @policy.access_key_id 
  xml.acl @policy.acl 
  xml.bucket @policy.bucket 
  xml.contentType @policy.content_type 
  xml.expires @policy.expiration_time 
  xml.key @policy.key 
  xml.secure false 
  xml.signature @policy.signature 
  xml.policy @policy.policy 
}
