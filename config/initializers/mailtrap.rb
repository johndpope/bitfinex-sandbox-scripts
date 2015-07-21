UserMailer.delivery_method = :smtp
new_config = {
	  :user_name => '395697b16859b7b30',
	  :password => '6b15504328c989',
	  :address => 'mailtrap.io',
	  :domain => 'mailtrap.io',
	  :port => '2525',
	  :authentication => :cram_md5
}
UserMailer.smtp_settings.merge!(new_config)

