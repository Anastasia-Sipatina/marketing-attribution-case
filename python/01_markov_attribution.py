# Markov attribution using ChannelAttribution library

import pandas as pd
import ChannelAttribution

# Expected input format:
# conversion_path: "google > youtube > direct"
# conversions: int
# zeropath: int (count of non-converting paths)

df = pd.read_csv("channel_paths_grouped.csv")  # example export from BigQuery
df["zeropath"] = df["zeropath"].fillna(0).astype(int)
df["Conversions"] = df["conversions"].astype(int)
df["Conversion_path"] = df["conversion_path"].astype(str)

result = ChannelAttribution.markov_model(
    df,
    var_path="Conversion_path",
    var_conv="Conversions",
    var_null="zeropath",
    order=1,
    sep=">",
    ncore=1,
    nfold=10,
    seed=0,
    conv_par=0.05,
    rate_step_sim=2,
    out_more=True,
    verbose=False,
)

attributed = result["result"].rename(columns={"total_conversions": "Attributed_conversions"})
removal_effects = result["removal_effects"]

print(attributed.head(20))
print(removal_effects.head(20))
