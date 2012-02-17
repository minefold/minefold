object @policy => 's3'

node(:accessKeyId) { @policy.access_key_id  }
node(:acl) { @policy.acl }
node(:bucket) { @policy.bucket }
node(:contentType) { @policy.content_type }
node(:expires) { @policy.expiration_time }
node(:key) { @policy.key }
node(:secure) { false }
node(:signature) { @policy.signature }
node(:policy) { @policy.policy }
