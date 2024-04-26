class Post < ApplicationRecord
  belongs_to :user
  # has_one_attached :thumbnail
  # has_one_attached :banner

  # has_rich_text :body
   acts_as_votable

  validates :url, length: { minimum: 5}
  # validates :body, length: { minimum: 25}

  self.per_page = 3
  # extend FriendlyId
  # friendly_id :title, use: :slugged

  def get_id_video(url)
    match = url.match(/(?:\/|%3D|v=|vi=)([0-9A-z_-]{11})(?:[%#?&]|$)/)

    return match[1] if match
  end

  require 'net/http'
  require 'json'
  def get_details(id)
      api_key = 'AIzaSyArmBieDIcbT6oZRQ6_OGuO2Anv3OT7h_A'
      uri = URI("https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{id}&fields=items/snippet&key=#{api_key}")
      response = Net::HTTP.get_response(uri)
      if response.code == '200'
          json_data = JSON.parse(response.body)
          video = json_data['items']
          title = video[0]['snippet']['title']
          content = video[0]['snippet']['description']
          # @content = video[0]['snippet']['description'].gsub("\n", "<br>")
          return title,content
      else
          puts "Error: #{response.code} - #{response.message}"
          return nil
      end
  end

end
