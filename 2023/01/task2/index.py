import re

file = open("../input.test.txt", "r")

inputs = file.readlines()
file.close()

result = 0

for line in inputs:
    line = line.replace("one", "1").replace("two", "2").replace("three", "3").replace("four", "4").replace("five", "5").replace("six", "6").replace("seven", "7").replace("eight", "8").replace("nine", "9")
    print(line)

    firstNumber = 0
    lastNumber = 0
    nums = re.findall(r'[0-9]', line)
    firstNumber = int(nums[0])
    lastNumber = int(nums[-1])

    print(str(firstNumber) + " " + str(lastNumber))

    result += 10 * firstNumber + lastNumber
    pass

print(result)
