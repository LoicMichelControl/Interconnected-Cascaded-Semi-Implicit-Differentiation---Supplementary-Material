# Interconnected-Cascaded-Semi-Implicit-Differentiation---Supplementary-Material

    "An interconnected discrete time cascaded semi-implicit differentiation"
    
    Code associated to the work submitted to the VSS'24 conference
    
    (c) [2024]  Nantes Université - Centrale Nantes - LS2N UMR 6004, Nantes
    (c) [2024]  Quartz EA 7393, ENSEA, Cergy-Pontoise
    Loïc MICHEL, Malek GHANES, Yannick AOUSTIN and Jean-Pierre BARBOT
    All rights reserved under MIT license.
    
    This code runs all numerical examples given in the paper.
    Simply execute 'RUN_VSS_results.m' and all cases are displayed
    successively. In addition, the figures are saved in the sub-directory 'Results'
    and the associated statistics w.r.t. the estimation errors
    are saved in the 'Result_error_evaluation.txt' file.

    The following cases are simulated:

    + Case #1 - Cascade including correction terms and knowledge of 'u'
    + Case #2 - Cascade including correction terms BUT without knowledge of 'u'
    + Case #3 - Cascade without correction terms and without knowledge of 'u'
    + Case #4 - Cascade including correction terms and knowledge of 'u' ->
    Addition of noise (under theta = 0)
    + Case #5 - Cascade including correction terms and knowledge of 'u' ->
    Addition of noise (under theta = 0.1)
    + Case #6 - Cascade including correction terms and knowledge of 'u' ->
    Addition of noise (under theta = 0.4)
    + Case #7 - Cascade including correction terms and knowledge of 'u' ->
    Addition of noise (under theta = 0.5)
