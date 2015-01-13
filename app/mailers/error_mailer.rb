class ErrorMailer < ActionMailer::Base

  def error_report
    mail(from: 'neil@metamorphium.com', to: 'neil@metamorphium.com', subject: 'Flocks have stopped polling! :(') do |format|
      format.html
      format.text
    end

  end

end
