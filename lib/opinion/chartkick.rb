# Options for highcharts
if Opinion.configuration.charts_engine == :highcharts
	libary_options = {plotOptions: {
			pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
							enabled: false
					},
					showInLegend: true
			}
	}}
elsif Opinion.configuration.charts_engine == :google_charts
	# TODO
	libary_options = {}
end

unless libary_options.empty?
	Chartkick.options = {
			library: libary_options
	}
end
