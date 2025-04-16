#String literal
a: str = "Hello"
b: str = "He\"ll\"o"
c: str = "He\\\"llo"


def check_flags(flags: [bool]) -> bool:
    i: int = 0
    while i < len(flags):
        if not flags[i]:
            return False
        i = i + 1
    return True


class Util(object):
    def __init__(self: "Util"):
        pass

    def toggle(self: "Util", flags: [bool]):
        i: int = 0
        while i < len(flags):
            flags[i] = not flags[i]
            i = i + 1

def main():
    flags = [[True, False], [True, True]]
    u = Util()

    if check_flags(flags[1]):
        print("All true")

    u.toggle(flags[0])

    if not check_flags(flags[0]) or flags[1][0] and flags[1][1]:
        print("Mixed flags")

    val = None
    if val is None:
        print("None check passed")

    result = 1 if flags[0][0] else 0
    print(result)

main()
