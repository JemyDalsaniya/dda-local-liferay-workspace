import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom';

import Chart from './Chart';

const AppComponent = () => {

	const [isSectionCollapsed, setIsSectionCollapsed] = useState(false);

	const [isLoading, setIsLoading] = useState(false);
	const [responseMessage, setResponseMessage] = useState('');
	const [chartData, setChartData] = useState();

	const fetchMessage = async (query) => {
		setIsLoading(true);
		try {
			const myHeaders = new Headers();
			myHeaders.append("Authorization", "6d4e5fdd887d596786dfc616b025ee5f");
			myHeaders.append("Content-Type", "application/json");

			const requestBody = JSON.stringify({
				query: {
					content: query,
				},
				history: null,
			});

			const response = await fetch("https://dda-genai.eastus.cloudapp.azure.com/api/generate_response", {
				method: "POST",
				headers: myHeaders,
				body: requestBody,
				redirect: "follow",
			});
			setIsLoading(false);
			if (!response.ok) {
				return {
					error: response.status,
					response: themeDisplay.getLanguageId()=='ar_SA'? 'لا يوجد رد لسؤالك الحالي٫ الرجاء اعادة المحاولة باستخدام سؤال اخر': 'No valid response can be returned from your inquery, please try another prompt'
				}
			}

			const result = await response.json();
			return result;
		} catch (error) {
			console.error("Error fetching message:", error);
			throw error;
		}
	};
	const sendMessage = async (query) => {
		const apiRresponse = await fetchMessage(query);
		setResponseMessage(apiRresponse.response);
		if (apiRresponse.data) {
			setChartData(apiRresponse.data);
		}

	}

	useEffect(() => {

		const urlObject = new URL(window.location.href);
		const query = urlObject.searchParams.get('t');
		if (query) {
			sendMessage(query);
		} else {
			setIsSectionCollapsed(true);
		}
	}, []);


	return (
		!isSectionCollapsed ? <div>
			<div className="px-60 pt-20 pb-55 bg-gray1">
				{isLoading && <div>Loading ...</div>}
				{responseMessage && <div>
					<div className='flex items-center gap-10 font-18 font-bold mb-16'>
						<div>
							<img src="data:image/png;base64,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" />
						</div>
						<span>GenAI Results</span>
					</div>
					<div dangerouslySetInnerHTML={{ __html: responseMessage }} />
				</div>}
			</div>

			{chartData && <div className='px-60 pt-30 pb-25 bg-gray2'>
				<div className=''>
					<div>
						<div className='mb-16 font-18 font-bold'>Visualize the Data</div>
						<div className='max-w-520'>
							<Chart options={chartData} />
						</div>
					</div>
				</div>
			</div>}
		</div> : ''
	);
};

export default AppComponent;