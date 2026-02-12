import random

# --- 常量 ---
SECPK1_P = 2**256 - 2**32 - 977
SECPK1_N = 115792089237316195423570985008687907852837564279074904382605163141518161494337
SECPK1_A = 0
SECPK1_B = 7
SECPK1_Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240
SECPK1_Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424

# --- 核心数学函数 ---


def ec_add(P1, P2):
    if not P1:
        return P2
    if not P2:
        return P1
    x1, y1, x2, y2 = P1[0], P1[1], P2[0], P2[1]
    if x1 == x2 and y1 != y2:
        return None
    if x1 == x2:
        m = (3 * x1 * x1 + SECPK1_A) * pow(2 * y1, -1, SECPK1_P) % SECPK1_P
    else:
        m = (y2 - y1) * pow(x2 - x1, -1, SECPK1_P) % SECPK1_P
    x3 = (m * m - x1 - x2) % SECPK1_P
    y3 = (m * (x1 - x3) - y1) % SECPK1_P
    return (x3, y3)


def ec_mul(k, Point):
    res = None
    base = Point
    while k:
        if k & 1:
            res = ec_add(res, base)
        base = ec_add(base, base)
        k >>= 1
    return res


def main():
    # Alice 原始数据
    r_a = 0xab1dcd2a2a1c697715a62eb6522b7999d04aa952ffa2619988737ee675d9494f
    s_a = 0x2b50ecce40040bcb29b5a8ca1da875968085f22b7c0a50f29a4851396251de12
    h_a = 0x87f1c8cd4c0e19511304b612a9b4996f8c2bd795796636bd25812cd5b0b6a973

    # 恢复公钥 Q
    y2 = (pow(r_a, 3, SECPK1_P) + SECPK1_B) % SECPK1_P
    R = (r_a, pow(y2, (SECPK1_P + 1) // 4, SECPK1_P))

    Q = ec_mul(pow(r_a, -1, SECPK1_N), ec_add(ec_mul(s_a, R), (ec_mul(h_a,
               (SECPK1_Gx, SECPK1_Gy))[0], SECPK1_P - ec_mul(h_a, (SECPK1_Gx, SECPK1_Gy))[1])))

    # 伪造
    while True:
        u1, u2 = random.randint(1, SECPK1_N-1), random.randint(1, SECPK1_N-1)
        p1 = ec_add(ec_mul(u1, (SECPK1_Gx, SECPK1_Gy)), ec_mul(u2, Q))
        if not p1:
            continue
        r_f = p1[0] % SECPK1_N
        s_f = (r_f * pow(u2, -1, SECPK1_N)) % SECPK1_N
        e_f = (u1 * s_f) % SECPK1_N

        if 0 < e_f < 2**256:
            v = 27 + (p1[1] % 2)
            if s_f > SECPK1_N // 2:
                s_f = SECPK1_N - s_f
                v = 28 if v == 27 else 27
            print(f"forgedAmountHex: {hex(e_f)}")
            print(
                f"forgedAliceSig: 0x{hex(r_f)[2:].zfill(64)}{hex(s_f)[2:].zfill(64)}{hex(v)[2:].zfill(2)}")
            break


if __name__ == "__main__":
    main()
