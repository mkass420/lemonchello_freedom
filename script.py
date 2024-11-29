import pandas as pd

csvfile = pd.read_csv("filename.csv", sep=';')

for i, row in csvfile.iterrows():
    num = len(row.tolist())
    if num != 10:
        csvfile.drop(i)

csvfile.to_csv("output.csv", index=False, sep=';')
