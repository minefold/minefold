CLOBBER.add 'public/flash/s3upload.swf'

file 'public/flash/s3upload.swf' => FileList['app/assets/flash/*.hx'] do |f|
  exec "haxe -cp ./app/assets/flash -main S3Upload -swf #{f.name} -swf-version 9"
end
