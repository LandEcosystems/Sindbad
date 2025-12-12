export ErrorMetricsTypes
abstract type ErrorMetricsTypes end
purpose(::Type{ErrorMetricsTypes}) = "Abstract type for error metrics in SINDBAD"
# ------------------------- metric -------------------------
export ErrorMetric
export MSE
export NAME1R
export NMAE1R
export NNSE
export NNSEInv
export NNSEσ
export NNSEσInv
export NSE
export NSEInv
export NSEσ
export NSEσInv
export NPcor
export NPcorInv
export Pcor
export PcorInv
export Pcor2
export Pcor2Inv
export NScor
export NScorInv
export Scor
export ScorInv
export Scor2
export Scor2Inv


abstract type ErrorMetric <: ErrorMetricsTypes end
purpose(::Type{ErrorMetric}) = "Abstract type for performance metrics in SINDBAD"

struct MSE <: ErrorMetric end
purpose(::Type{MSE}) = "Mean Squared Error: Measures the average squared difference between predicted and observed values"

struct NAME1R <: ErrorMetric end
purpose(::Type{NAME1R}) = "Normalized Absolute Mean Error with 1/R scaling: Measures the absolute difference between means normalized by the range of observations"

struct NMAE1R <: ErrorMetric end
purpose(::Type{NMAE1R}) = "Normalized Mean Absolute Error with 1/R scaling: Measures the average absolute error normalized by the range of observations"

struct NNSE <: ErrorMetric end
purpose(::Type{NNSE}) = "Normalized Nash-Sutcliffe Efficiency: Measures model performance relative to the mean of observations, normalized to [0,1] range"

struct NNSEInv <: ErrorMetric end
purpose(::Type{NNSEInv}) = "Inverse Normalized Nash-Sutcliffe Efficiency: Inverse of NNSE for minimization problems, normalized to [0,1] range"

struct NNSEσ <: ErrorMetric end
purpose(::Type{NNSEσ}) = "Normalized Nash-Sutcliffe Efficiency with uncertainty: Incorporates observation uncertainty in the normalized performance measure"

struct NNSEσInv <: ErrorMetric end
purpose(::Type{NNSEσInv}) = "Inverse Normalized Nash-Sutcliffe Efficiency with uncertainty: Inverse of NNSEσ for minimization problems"

struct NSE <: ErrorMetric end
purpose(::Type{NSE}) = "Nash-Sutcliffe Efficiency: Measures model performance relative to the mean of observations"

struct NSEInv <: ErrorMetric end
purpose(::Type{NSEInv}) = "Inverse Nash-Sutcliffe Efficiency: Inverse of NSE for minimization problems"

struct NSEσ <: ErrorMetric end
purpose(::Type{NSEσ}) = "Nash-Sutcliffe Efficiency with uncertainty: Incorporates observation uncertainty in the performance measure"

struct NSEσInv <: ErrorMetric end
purpose(::Type{NSEσInv}) = "Inverse Nash-Sutcliffe Efficiency with uncertainty: Inverse of NSEσ for minimization problems"

struct NPcor <: ErrorMetric end
purpose(::Type{NPcor}) = "Normalized Pearson Correlation: Measures linear correlation between predictions and observations, normalized to [0,1] range"

struct NPcorInv <: ErrorMetric end
purpose(::Type{NPcorInv}) = "Inverse Normalized Pearson Correlation: Inverse of NPcor for minimization problems"

struct Pcor <: ErrorMetric end
purpose(::Type{Pcor}) = "Pearson Correlation: Measures linear correlation between predictions and observations"

struct PcorInv <: ErrorMetric end
purpose(::Type{PcorInv}) = "Inverse Pearson Correlation: Inverse of Pcor for minimization problems"

struct Pcor2 <: ErrorMetric end
purpose(::Type{Pcor2}) = "Squared Pearson Correlation: Measures the strength of linear relationship between predictions and observations"

struct Pcor2Inv <: ErrorMetric end
purpose(::Type{Pcor2Inv}) = "Inverse Squared Pearson Correlation: Inverse of Pcor2 for minimization problems"

struct NScor <: ErrorMetric end
purpose(::Type{NScor}) = "Normalized Spearman Correlation: Measures monotonic relationship between predictions and observations, normalized to [0,1] range"

struct NScorInv <: ErrorMetric end
purpose(::Type{NScorInv}) = "Inverse Normalized Spearman Correlation: Inverse of NScor for minimization problems"

struct Scor <: ErrorMetric end
purpose(::Type{Scor}) = "Spearman Correlation: Measures monotonic relationship between predictions and observations"

struct ScorInv <: ErrorMetric end
purpose(::Type{ScorInv}) = "Inverse Spearman Correlation: Inverse of Scor for minimization problems"

struct Scor2 <: ErrorMetric end
purpose(::Type{Scor2}) = "Squared Spearman Correlation: Measures the strength of monotonic relationship between predictions and observations"

struct Scor2Inv <: ErrorMetric end
purpose(::Type{Scor2Inv}) = "Inverse Squared Spearman Correlation: Inverse of Scor2 for minimization problems"
