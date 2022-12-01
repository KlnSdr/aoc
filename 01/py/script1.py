fileName: str = "data.txt"

rawData: str = "";
with open(fileName) as file:
    for line in file.readlines():
        rawData += line
        pass
    pass

data: list[str] = rawData.split("\n")

maxCal: int = -1
currentCal: int = 0

for val in data:
    if val == "":
        if currentCal > maxCal:
            maxCal = currentCal
            pass
        currentCal = 0
        pass
    else:
        currentCal += int(val)
        pass
    pass

print(maxCal)
