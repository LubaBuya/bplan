ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "ucbplan.com",
  :user_name            => "ucbplan@gmail.com",
  :password             => "eventsmtwgr",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
