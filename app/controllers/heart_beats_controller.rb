class HeartBeatsController < ApplicationController
  # before_action :check_api_key

  def measure
  end

  def index
    User.first.heart_beats.create(beat_date_time: Time.now, heart_beat: params[:heart_beat])
    puts "create!!"
    render nothing: true
  end

  private
  def heart_beat_params
    params.require(:heart_beat).permit(:heart_beat)
  end

  # api keyのチェック
  def check_api_key
    if request.headers['api-key'] == "test_key"
      puts "accept"
      return true
    else
      puts "not accept"
      render json: {message: "api-key error"}.to_json, status:400
    end
  end
end
