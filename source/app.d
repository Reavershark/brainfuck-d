import std.stdio;

int main(string[] argv)
{
    if (argv.length < 2) {
        writeln("Usage: " ~ argv[0] ~ " source.b");
        return 1;
    }

    auto file = File(argv[1]);
    string instructionset = "><+-.,[]";
    string code = "";
    foreach (line; file.byLine()) {
        foreach (chr; line) {
            foreach(instruction; instructionset) {
                if (chr == instruction) {
                    code ~= chr;
                }
            }
        }
    }

    char* ptr;
    char[1024^^2] array = 0;
    ptr = array.ptr;

    for(int i = 0; i < code.length; i++) {
        switch(code[i]) {
            case '>':
                ++ptr;
                break;
            case '<':
                --ptr;
                break;

            case '+':
                ++*ptr;
                break;
            case '-':
                --*ptr;
                break;

            case '.':
                putchar(*ptr);
                break;
            case ',':
                *ptr = cast(char)(getchar());
                break;

            case '[':
                if (*ptr == 0) {
                    i = findJump(code, i, true);
                }
                break;
            case ']':
                if (*ptr != 0) {
                    i = findJump(code, i, false);
                }
                break;

            default:
                break;
        }
    }
    return 0;
}

int findJump(string str, int i, bool direction) {
    char chr = str[i];
    bool found = false;
    int count = 0;
    if (direction) {
        while (!found) {
            i++;
            chr = str[i];
            if (chr == '[') {
                count++;
            } else if (chr == ']' && count != 0) {
                count--;
            } else if (chr == ']' && count == 0) {
                found = true;
                break;
            }
        }
    } else {
        while (!found && i != 0) {
            i--;
            chr = str[i];
            if (chr == ']') {
                count++;
            } else if (chr == '[' && count != 0) {
                count--;
            } else if (chr == '[' && count == 0) {
                found = true;
                break;
            }
        }
    }
    return i;
}
