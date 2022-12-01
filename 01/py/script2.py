fileName: str = "data.txt"

maxCal: list[int] = [-1, -1, -1]
currentCal: int = 0

def addPotMax(value: int):
    global maxCal

    if value > maxCal[0]:
        maxCal = [value, maxCal[0], maxCal[1]]
        pass
    elif value > maxCal[1]:
        maxCal = [maxCal[0], value, maxCal[1]]
        pass
    elif value > maxCal[2]:
        maxCal = [maxCal[0], maxCal[1], value]
        pass
    pass

rawData: str = "";
with open(fileName) as file:
    for line in file.readlines():
        rawData += line
        pass
    pass

data: list[str] = rawData.split("\n")

for val in data:
    if val == "":
        addPotMax(currentCal)
        currentCal = 0
        pass
    else:
        currentCal += int(val)
        pass
    pass

print(maxCal[0] + maxCal[1] + maxCal[2])
