//
//  HomeChart.swift
//  Expense Tracker
//
//  Created by Lucio on 06/08/2022.
//

import UIKit
import Charts

class HomeChart: BarChartView {
    
    private var homeChartMarker: ChartMarkerView = ChartMarkerView.fromNib()
    private var transactions: [Transaction] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialConfig()
    }
    
    func updateChartData(_ transactions: [Transaction]) {
        self.transactions = transactions
        let chartDataEntries = transactions.enumerated().map { index, transaction in BarChartDataEntry(x: Double(index), y: transaction.amount) }
        let axisValue = IndexAxisValueFormatter(values: transactions.map { $0.day })
        
        let chartDataSet = BarChartDataSet(entries: chartDataEntries)
        chartDataSet.setColor(UIColor.primary)
        chartDataSet.barShadowColor = UIColor.secondary
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartData.highlightEnabled = true
        
        updateXAsixValue(axisValue)
        
        onConfigChartMarker()
        
        data = chartData
        
        notifyDataSetChanged()
    }
    
    func updateXAsixValue(_ axisValue: IndexAxisValueFormatter) {
        xAxis.valueFormatter = axisValue
        configXAxis(Double(axisValue.values.count))
    }
    
    fileprivate func onConfigChartMarker() {
        highlightValue(nil)
        marker = homeChartMarker
        homeChartMarker.chartView = self
    }
    
    fileprivate func configXAxis(_ numberOfData: Double) {
        xAxis.setLabelCount(Int(numberOfData), force: false)
        xAxis.axisMaximum = numberOfData
    }
    
    private func initialConfig() {
        delegate = self
        drawGridBackgroundEnabled = false
        backgroundColor = .clear
        xAxis.labelPosition = .bottom
        xAxis.gridLineWidth = 0.0
        xAxis.axisLineWidth = 0.0
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = -25
        
        legend.enabled = false
        chartDescription?.enabled = false
        setScaleEnabled(true)
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = true
        leftAxis.enabled = false
        animate(yAxisDuration: 1.2)
        highlightPerTapEnabled = true
        highlightFullBarEnabled = true
        highlightPerDragEnabled = false
        setExtraOffsets(left: 10, top: 0, right: 20, bottom: 0)
    }


}

extension HomeChart: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        
        let entryIndex = dataSet.entryIndex(entry: entry)
        
        let transaction = transactions[entryIndex]
        
        homeChartMarker.update(transaction)
    }
    
}
