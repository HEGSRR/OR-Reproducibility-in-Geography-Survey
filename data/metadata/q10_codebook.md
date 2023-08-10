# Data Dictionary for Q10 Coding

- `ResponseId`: Unique anonymous identifier for each response
- `Q3_recoded.x`: Which subfield of geography, of domain {Human, Nature/Society, Physical, Methods}
- `Q4.x`: Which method of geography, of domain {Qualitative, Quantitative, Mixed Methods}
- `Q10`: Qualitative response to the question: Thinking about the reproduction(s) you attempted in the last 2 years, what made you decide to attempt the reproduction(s)?
  - `NA`: No response
- `consensus`: The research team coded Q10 responses with the best fit of five different motivations (domain of integers [1:5]) for the reproduction attempt:
  - `1`: Verification/Peer-Review : these respondents either reproduced a study as part of peer review or independent review process, or to independently verify the procedures and results of a study.
  - `2`: Self-check/Promote transparency of own work : these respondents wanted to ensure that their own research was reproducible
  - `3`: Replication : These researchers were actually implementing something more aligned with the NASEM definition of replication, in which new data is collected or the conditions of the study are intentionally altered.
  - `4`: Teaching/Learning : These researchers were interested in using reproduction studies to learn methods in published research, to teach students, and/or to learn for the purpose of eventually repurposing or extending prior work.
  - `5`: Missing : There was too little explicit information in the Q10 answer to code the response, or Q10 was left blank (`NA`)
- `notes`: Researcher notes about interpreting motivations expressed in Q10
