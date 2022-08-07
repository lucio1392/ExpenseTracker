//
//  HomeChart.swift
//  Expense Tracker
//
//  Created by Lucio on 06/08/2022.
//

import UIKit
import Charts

class HomeChart: BarChartView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfig()
    }
    
    func updateChartData(_ chartDataEntry: [BarChartDataEntry]) {
        let chartDataEntries = chartDataEntry
        
        let chartDataSet = BarChartDataSet(entries: chartDataEntries)
        chartDataSet.setColor(UIColor(hexString: "#1a1b32"))
        chartDataSet.barShadowColor = UIColor(hexString: "#f6f6f6")
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.highlightEnabled = false
        
        data = chartData
        
        notifyDataSetChanged()
    }
    
    func updateXAsixValue(_ axisValue: IndexAxisValueFormatter) {
        xAxis.valueFormatter = axisValue
        configXAxis(Double(axisValue.values.count))
    }
    
    fileprivate func configXAxis(_ numberOfData: Double) {
        xAxis.setLabelCount(Int(numberOfData), force: false)
        xAxis.axisMaximum = numberOfData
    }
    
    fileprivate func configYAxisRight() {
        
    }
    
    private func initialConfig() {
        drawBarShadowEnabled = true
        drawGridBackgroundEnabled = false
        backgroundColor = .clear
        xAxis.labelPosition = .bottom
        xAxis.gridLineWidth = 0.0
        xAxis.axisLineWidth = 0.0
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = -25
        rightAxis.axisLineWidth = 0.0
        rightAxis.gridLineWidth = 0.0
        legend.enabled = false
        chartDescription?.enabled = false
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = false
        leftAxis.enabled = false
        animate(yAxisDuration: 1.2)
    }


}
