# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data, :blob,
                       "https://*.googleapis.com",
                       "https://*.gstatic.com",
                       "https://*.google.com"
    policy.object_src  :none
    policy.script_src  :self, :https, :unsafe_inline, :unsafe_eval,
                       "https://maps.googleapis.com",
                       "https://maps.gstatic.com",
                       "https://*.gstatic.com"
    policy.style_src   :self, :https, :unsafe_inline,
                       "https://fonts.googleapis.com"
    policy.connect_src :self, :https,
                       "https://*.googleapis.com",
                       "https://*.gstatic.com",
                       "https://*.google.com"
  end
end
