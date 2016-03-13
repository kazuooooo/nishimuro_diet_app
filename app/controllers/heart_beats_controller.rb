class HeartBeatsController < ApplicationController
  # before_action :check_api_key

  def measure
  end
  def graph
    time  = User.first.heart_beats.pluck(:beat_date_time).map {|time| time.strftime('%H:%M:%S')}
    beats = User.first.heart_beats.pluck(:heart_beat)
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '心拍数')
      f.xAxis(categories: time)
      f.series(name: '心拍', data: beats)
    end

    # category = [1,3,5,7]
    # current_quantity = [1000,5000,3000,8000]
    #
    # @graph = LazyHighCharts::HighChart.new('graph') do |f|
    #   f.title(text: 'ItemXXXの在庫の推移')
    #   f.xAxis(categories: category)
    #   f.series(name: '在庫数', data: current_quantity)
    # end
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
