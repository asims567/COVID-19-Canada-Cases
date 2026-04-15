# COVID-19-Canada-Cases
This dataset, provided by the Public Health Agency of Canada, covers COVID-19 cases across all provinces and territories from January 2020 to September 2024.




## CFR - Case Fatality Rate Analysis
Case Fatality Risk (CFR) plot analysis is used to measure the severity of a disease outbreak. It involves tracking cases within a population and identifying patterns. 


<img width="341" height="242" alt="CFR Plot" src="https://github.com/user-attachments/assets/2e52f235-8375-4f2c-84e8-8d7e9867efb2" />

The provided plot captures the multi-phase evolution of the COVID-19 Case Fatality Rate (CFR) in Canada, reflecting a dramatic shift from a high-severity crisis to a stabilized endemic state by 2024. The initial surge to nearly 10% in early to mid-2020 was driven by extreme case counts due to vulnerability in long-term care settings and restricted testing that captured only the most severe cases. In 2021 and 2022, there was a sharp decline as testing capacity expanded, and the rollout of vaccines significantly reduced mortality counts. As of 2026, COVID-19 activity in Canada has transitioned to a seasonal respiratory pattern, similar to the flu (influenza), with a low percent positivity of 2.7%. 



## Specific Analysis of Weekly Deaths, Ontario Vs Quebec


<img width="513" height="318" alt="Rplot01" src="https://github.com/user-attachments/assets/92db30a9-f705-41f0-8930-503c46c90e3a" />


The box plot shows a comparison of Ontario and Quebec weekly COVID-19 deaths and provides statistical insight. I want to identify similarities or major differences in the death count of the specific provinces of Ontario and Quebec, since there is a huge population difference in these provinces, and test them.  The following are statistical test results:

## Welch Two Sample t-test
**Comparison:** Weekly Deaths — Ontario vs Quebec (`numdeaths_last7`)

| Statistic | Value |
|-----------|-------|
| t-statistic | -0.69284 |
| Degrees of Freedom | 450.06 |
| p-value | 0.4888 |
| Significance | Not significant (p > 0.05) |
| Alternative Hypothesis | True difference in means ≠ 0 |
| 95% CI Lower | -26.634 |
| 95% CI Upper | 12.749 |
| Mean — Ontario | 77.988 |
| Mean — Quebec | 84.930 |

From the numbers above, we can conclude that even though the raw average for Quebec appears higher, the high p-value tells us that the overlap between the two provinces' data is too great to claim one was harder hit than the other in a statistically meaningful way. Both provinces followed very similar mortality trajectories over the course of the reporting period.

