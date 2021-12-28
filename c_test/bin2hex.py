with open('simple', 'rb') as binary:
    data = binary.read()
    for i in range(0, len(data), 4):
        print(int.from_bytes(data[i:i+4], 'little').to_bytes(4, 'big').hex())
