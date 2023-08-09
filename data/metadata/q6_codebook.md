# Data Dictionary for Q6 Coding

Relevant identifier and population information is contained in the first columns, and relevant rectified coding is contained in the final columns.

- `ResponseId`: Unique anonymous identifier for each response
- `Q3_recoded.x`: Which subfield of geography, of domain {Human, Nature/Society, Physical, Methods}
- `Q4.x`: Which method of geography, of domain {Qualitative, Quantitative, Mixed Methods}
-	`Q6.x`: Qualitative definition of "reproducibility"
- `dat_rec`: Does the definition emphasize the use of the same data inputs?
  - `0`: No
  - `1`: Yes
- `pro_rec`: Does the definition emphasize the use of the same procedures or methods?
  - `0`: No
  - `1`: Yes
- `res_rec`: Does the definition emphasize finding the same results or similar results within an expected range?
  - `0`: No
  - `1`: Yes
- `con_rec`: Does the definition emphasize conducting the study in the same conditions, which may include the same computational environment?
  - `0`: No
  - `1`: Yes
- `Rejection`: Does the definition include expressions rejecting the meaning or role of reproducibility, especially on epistemological grounds?
  - `0`: No
  - `1`: Yes
- `Sum`: Arithmetic sum of data_rec, pro_rec, res_rec, and con_rec with possible domain of integers [0:1]. A high sum indicates close alignment with the NASEM 2019 definition, while a low sum indicates divergence.
- `label`: Definitions were classified as one of four possible archetypes of motivations for conducting a replication study.
  - `Data Collection`: improve the transparency and consistency of data collection
  - `Standard`: facilitate assessment of prior work, most in line with the NASEM 2019 definition
  - `Experiment`: assess experimental research
  - `Transparency`: improve transparency and facilitate further extension of work
- `replication_flag`: Does the definition more closely align with the NASEM 2019 definition of "replication", in which a study is repeated with new data or new context, than it does "reproducibility"?
  - `0`: No
  - `1`: Yes
