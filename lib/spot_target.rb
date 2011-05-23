# depricated 11/30/2010 -- JACK     

# INSERT INTO brand_colors (name, spectral_1, spectral_2, spectral_3, spectral_4, spectral_5, spectral_6, spectral_7, spectral_8, spectral_9, spectral_10, spectral_11, spectral_12, spectral_13, spectral_14, spectral_15, spectral_16, spectral_17, spectral_18, spectral_19, spectral_20, spectral_21, spectral_22, spectral_23, spectral_24, spectral_25, spectral_26, spectral_27, spectral_28, spectral_29, spectral_30, spectral_31)
# 
# 
# Values("134 Tan",
# 6.246943,12.176888,18.832695,20.552706,20.401028,20.368551,20.759094,21.269619,23.449207,31.291733,43.290749,52.071918,54.857315,55.685822,57.167522,60.664833,66.822426,74.312218,80.335754,83.007523,83.73571,83.950928,84.08506,84.613846,85.204803,85.701759,85.684448,85.499649,85.136742,85.30368,85.829941)
#   
module SpotTarget
  
  def hersheys_spectral_targets
    spectral_targets = {'072 Blue' => [3.669752,12.188051,25.416752,32.78278,35.735252,35.145561,31.994448,27.16045,20.721947,13.972901,7.777092,3.357839,1.197754,0.543098,0.361822,0.333493,0.291829,0.281607,0.262011,0.281275,0.283381,0.297586,0.318926,0.321653,0.342507,0.377928,0.449609,0.544469,0.756046,1.237077,2.029054] } 
    spectral_targets["130 Orange"] = [1.707757,2.004281,2.156349,2.169441,2.19644,2.168289,2.140111,2.335294,2.867506,5.495879,14.967198,30.971825,39.690872,41.300251,41.568703,40.519794,37.163422,34.860104,43.031597,61.149918,75.240112,80.59845,82.277252,83.280106,84.115128,84.670303,84.724823,84.607246,84.369858,84.572945,85.024857]
    spectral_targets["134 Tan"] = [6.246943,12.176888,18.832695,20.552706,20.401028,20.368551,20.759094,21.269619,23.449207,31.291733,43.290749,52.071918,54.857315,55.685822,57.167522,60.664833,66.822426,74.312218,80.335754,83.007523,83.73571,83.950928,84.08506,84.613846,85.204803,85.701759,85.684448,85.499649,85.136742,85.30368,85.829941]
    spectral_targets["186 Red"] = [1.435739,2.370911,3.415261,3.764821,3.706851,2.949739,1.907942,1.215572,0.800486,0.616485,0.573772,0.598661,0.603841,0.633756,0.675967,0.845418,1.271123,2.44867,7.815416,22.899197,41.054077,51.629765,56.164803,58.464478,59.823563,60.597168,61.125786,61.309067,61.328747,61.793629,62.379898] 
    spectral_targets["301 Blue"] = [3.200058,7.414764,13.515474,18.130461,22.008736,24.350048,25.048565,24.914162,23.760441,21.622347,18.502401,14.433912,10.005931,6.173134,3.591471,2.073014,1.204983,0.806139,0.633078,0.57293,0.537995,0.508481,0.536326,0.525377,0.519437,0.545231,0.613313,0.646158,0.647253,0.614815,0.628227] 
    spectral_targets["483 Brown"] = [1.167951,1.441512,1.622705,1.672372,1.697595,1.742425,1.730725,1.782623,1.98176,2.645063,3.325535,3.418524,2.968381,2.612103,2.461346,2.2101,1.783651,1.584674,2.802993,6.457296,10.08839,11.678074,12.291744,12.698272,13.026397,13.264161,13.503286,13.737541,13.917284,14.124979,14.377301] 
    spectral_targets["485 2X Red"] = [0.864,0.839,0.845,0.876,0.9,0.888,0.903,0.964,1.144,1.654,2.042,1.801,1.398,1.096,0.842,0.531,0.54,0,1.941,16.403,36.191002,55.991001,72.732002,81.332001,85.781998,88.228996,89.105003,89.449997,89.542,89.947998,90.435997] 
    spectral_targets["485 Red"] = [1.564854,1.827069,1.954473,1.976095,1.936596,1.983135,1.927224,2.001623,2.283703,3.429562,5.239846,5.986535,5.096934,4.29188,3.887321,3.401213,2.551421,2.186347,4.974015,18.977859,42.949997,63.208927,74.532211,80.154175,83.106903,84.700058,85.189011,85.255203,85.280899,85.967865,86.997253]  
    spectral_targets["504 Brown"] = [1.483209,2.251928,3.103202,3.439623,3.43092,3.093298,2.469772,1.952138,1.549012,1.324499,1.188271,1.172221,1.173401,1.175511,1.240354,1.454379,2.094821,3.272183,4.531703,5.230204,5.514257,5.710646,5.966083,6.320187,6.775239,7.297884,7.926853,8.692623,9.541862,10.531666,11.672077] 
    spectral_targets["877 Silver"] = [18.947617,21.741169,25.1096,26.529764,26.763,26.499874,26.116398,25.897045,25.617857,25.410669,25.245564,24.968513,24.697029,24.556822,24.460175,24.425568,24.297321,24.052937,23.949875,23.858812,23.749336,23.557365,23.451733,23.345451,23.222033,23.074629,23.006035,22.854767,22.705894,22.767704,22.635212]  
    spectral_targets["1235 Yellow"] = [3.327477,4.558403,5.586825,5.657793,5.57699,5.585842,5.684638,6.049991,7.175816,11.821856,21.89105,32.53624,37.496696,39.30621,41.19976,45.318657,53.560959,65.047363,75.718887,81.029984,82.838455,83.407944,83.596558,84.147667,84.759056,85.26329,85.216507,85.046127,84.794189,85.057434,85.403275] 
    spectral_targets["4625 Brown"] = [0.984301,1.091347,1.095886,1.126532,1.109036,1.130592,1.07316,1.093196,1.171601,1.360563,1.536424,1.567811,1.515209,1.469728,1.501761,1.718141,2.345521,3.439662,4.558849,5.22613,5.528224,5.683017,5.812595,5.954494,6.109392,6.225474,6.353617,6.483814,6.592641,6.701708,6.828238] 
    spectral_targets["4975 Brown"] = [1.142668,1.472141,1.804569,1.96648,1.953941,1.830978,1.526222,1.278579,1.07837,0.974625,0.916372,0.915218,0.930115,0.957654,1.023158,1.214841,1.765196,2.803204,3.918347,4.475867,4.553386,4.481813,4.490506,4.570547,4.72091,4.976361,5.305805,5.518424,5.539545,5.437664,5.238273]  
    spectral_targets["Kit Kat Red"] = [1.252,1.125,0.959,0.887,0.986,1.05,1.232,1.481,1.629,1.544,1.676,1.893,1.936,1.834,1.68,1.519,1.362,1.474,3.538,12.943,31.562,53.187,68.804001,76.521004,79.637001,80.919998,81.639999,82.406998,83.028,83.518997,83.922997]   
    spectral_targets["Munsell Maroon"] = [1.16,1.27,1.34,1.38,1.36,1.22,1.07,1.01,0.96,0.87,0.79,0.77,0.76,0.73,0.72,0.82,0.95,1.05,1.2,1.43,1.9,2.89,4.16,5.54,6.92,8.07,9.31,10.91,12.66,14.47,16.34] 
    spectral_targets["Pantone Yellow"] = [1.391615,1.544665,1.748929,1.783344,1.786253,1.799044,1.747194,1.948205,2.210689,4.101997,13.075537,37.655773,64.391251,77.067657,81.290771,83.113815,83.706818,83.635117,83.944427,84.201889,84.234528,84.206902,84.399597,85.021957,85.851654,86.504112,86.589951,86.350189,86.212784,86.658142,87.316345]
    spectral_targets["Reese Orange"] = [2.332,2.475,2.548,2.521,2.502,2.588,2.719,2.921,3.104,3.122,3.217,3.723,4.205,4.098,4.312,4.746,8.478,19.025,34.203999,55.355999,74.676003,82.253998,84.872002,86.294998,86.614998,87.051003,87.314003,87.517998,87.692001,87.900002,88.125999]   
    spectral_targets["Reflex Blue"] =  [3.167556,7.012087,12.838991,17.002209,19.802629,21.025425,20.393898,17.983746,14.039927,9.659651,5.680361,2.844089,1.353594,0.760939,0.520441,0.446541,0.39066,0.364073,0.344085,0.346252,0.35297,0.35922,0.381852,0.390818,0.409735,0.431115,0.477257,0.51914,0.590906,0.747334,1.119657] 
    return spectral_targets
  end 
   
end    