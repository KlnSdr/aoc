import re

file = open("../input.txt", "r")

inputs = file.readlines()
file.close()

result = 0

for line in inputs:
    firstNumber = 0
    lastNumber = 0
    nums = re.findall(r'[0-9]', line)
    firstNumber = int(nums[0])
    lastNumber = int(nums[-1])

    result += 10 * firstNumber + lastNumber
    pass

print(result)
