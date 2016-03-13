class HeartBeatsController < ApplicationController
  # before_action :check_api_key

  def measure
  end
  def graph
    beats_data = User.first.heart_beats.limit(200).order(id: :desc)
    time  = beats_data.pluck(:beat_date_time).map {|time| time.strftime('%H:%M:%S')}.reverse
    null_times = Array.new(198, "")
    times = [time.first, null_times.flatten, time.last]
    beats = beats_data.pluck(:heart_beat).reverse
    @all_calories = 0
    calories = beats.map do |beat|
      @all_calories += beat.to_f/ (220-34) * 40 * 1 / 12 * 62 / 1000 * 5
    end
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '心拍数/34歳/174cm/62kg/男性')
      f.xAxis(categories: times.flatten)
      f.options[:yAxis] = [{ title: { text: '心拍数' }}, { title: { text: '消費カロリー'}, opposite: true}]
      f.series(name: '消費カロリー',     data: calories, type: 'column', yAxis: 1)
      f.series(name: '心拍', data: beats, type: 'spline')
    end
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
