class AccessToken
  attr_reader :token
  def initialize(token)
    @token = token
  end

  def apply!(headers)
    headers['Authorization'] = "Bearer #{@token}"
  end

  def token
    @token
  end
end
#
# access_token = AccessToken.new 'SECRET_TOKEN'
# drive = Google::Apis::DriveV2::DriveService.new
# drive.authentication = access_token
# drive.list_files # works ( If you get unauthorized error ... refresh the access token )
