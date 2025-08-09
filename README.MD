# E-Commerce Data - Retail Evidence for Clustering Approach

- This project was devolopment to understand how segmentation works in the clients, we using Machine Learning Algorithms, in specific Unsupervisioned Learning. Using different tips for analyse customer segmentation on the database extract query. 

- Extremally important this data used by the kaggle project: [Ecommerce Data](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

- This project use different methods to apply of cluster how work the process for using PCA Algortihms (reduction the dimension), Kmeans (for cluster) and using Elbow method to find best way of obtain the number of the required cluster with data that have.

- Insights obtain for this approach, all of this things depends what your interest, what is metric more important to you in present moment, whats your experiment, what best allocation for the segmentation the customer on database that have. 

## File Structure: 
We using this structure:
```
retail-e-commerce-evidence/
├── analytics
│   ├── client_value.ipynb
│   ├── metrics_world.ipynb
│   └── retails.ipynb
├── data
│   └── data_encoding.csv
├── queries
│   ├── filter_values_returned.sql
│   ├── insert_varclients.py
│   ├── main_country_consumption.sql
│   ├── mostvalue_client.sql
│   └── retail.db
├── README.MD
├── requirements.txt
└── updates.txt
```
* analytics/: Contains all of the analysis, process segmentation and optization of the algorithm; you will see the process for categorization using `Kmeans`, `Elbow Method` and `PCA`. Here we using the method of RFM (Recency, Frequency, Monetary) important in the context for e-commerce, identify the oportunities and know more about your clients, potential new outcomes.

* data/: Basicly first data, not have treatment, will use to understand of data and the read for cleanning and filters data.

* queries/: Here we using .SQL methods to cleanning & manipulating database. We using also the `insert_varclients.py` to update database and make more alterations in the retail.db, we using this enviroment to cat the `data_encoding.csv` to guard in the `retail.db`, this process it very important to filter & cleanning the data.

## You can see the global revenue with the metric ARPU: 

* This metric consist in the 'Average Revenue Per User', we using to identify which country is better perform in the product, what have Customer more interest in therms of Revenue, we can see in this graph interactive: 

