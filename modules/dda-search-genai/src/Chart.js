import React, { useEffect, useRef } from 'react';


function loadScript(src, onLoad) {
    // Check if the script already exists
    if (document.querySelector(`script[src="${src}"]`)) {
        console.log(`Script already loaded: ${src}`);
        onLoad(); // Call the callback immediately if the script is already loaded
        return;
    }

    // If not, create and load the script
    const script = document.createElement('script');
    script.src = src;
    script.async = true;
    script.onload = onLoad;
    script.onerror = () => console.error(`Failed to load script: ${src}`);
    document.head.appendChild(script);
}

const buildChartObject = (chartData) => {
    let obj = {
        chart: {
            type: chartData.default_chart.type|| 'column',
            backgroundColor: '#f7f9fb',
            borderColor: '#d3d3d3',
            borderWidth: 1,
            marginTop: 50
        },
        title: {
            text: chartData.default_chart.title,
            align: 'left',
            x: 18,
            style: {
                color: '#333333',
                fontSize: '16px',
            }
        },
        legend: {
            enabled: false
        },
        xAxis: {
            categories: chartData.x.data,
            title: {
                text: chartData.x.title || 'X Axis'
            },
            lineColor: '#d0d2d3',
            labels: {
                style: {
                    fontSize: '10px'
                }
            }
        },
        yAxis: {
            title: {
                text: chartData.y.title || 'Y Axis'
            },
            labels: {
                style: {
                    fontSize: '10px'
                }
            }
        },
        series: [{
            name: chartData.y.title || 'Series',
            data: chartData.y.data,
            color: '#016da4'
        }],
        exporting: {
            enabled: false  // Disable exporting menu
        },
        credits: {
            enabled: false  // Disable the credits text
        },
        plotOptions: {
            column: {
                borderRadius: 5,
                pointPadding: 0.2,
                borderWidth: 0
            },
            series: {
                dataLabels: {
                    enabled: true,
                    format: '{y}'
                }
            }
        }
    }
    return obj;
}

const Chart = ({ options }) => {
    console.log('props', options);
    const chartData = options;
    console.log(`chart.js`, chartData);
    const chartContainerRef = useRef(null);


    const chartOptions = buildChartObject(chartData);


    useEffect(() => {
        const loadHighcharts = () => {
            window.Highcharts.chart(chartContainerRef.current, chartOptions);
        };

        loadScript('https://code.highcharts.com/highcharts.js', loadHighcharts);
    }, []);

    return <div className='rounded-20 h-250' ref={chartContainerRef}></div>;
};

export default Chart;