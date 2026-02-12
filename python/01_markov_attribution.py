# Markov attribution using ChannelAttribution library

import pandas as pd
import ChannelAttribution

# Load grouped paths
df = pd.read_csv("channel_paths_grouped.csv")

# Rename and clean columns
df = df.rename(columns={
    "conversion_path": "path",
    "conversions": "conversions",
    "zeropath": "null_conversions"
})

df["null_conversions"] = df["null_conversions"].fillna(0).astype(int)
df["conversions"] = df["conversions"].astype(int)
df["path"] = df["path"].astype(str)

if df.empty:
    raise ValueError("Input dataframe is empty.")

result = ChannelAttribution.markov_model(
    df,
    var_path="path",
    var_conv="conversions",
    var_null="null_conversions",
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

# Extract results
attributed = result["result"].rename(
    columns={"total_conversions": "Attributed_conversions"}
)

removal_effects = result["removal_effects"]

print("Attributed conversions:")
print(attributed.head(20))

print("\nRemoval effects:")
print(removal_effects.head(20))

