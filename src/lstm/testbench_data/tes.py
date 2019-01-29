import numpy as np
from numpy import genfromtxt

W_a = genfromtxt('wa_2', delimiter=',')
W_i = genfromtxt('wi_2', delimiter=',')
W_f = genfromtxt('wf_2', delimiter=',')
W_o = genfromtxt('wo_2', delimiter=',')
U_a = genfromtxt('ua_2', delimiter=',')
U_i = genfromtxt('ui_2', delimiter=',')
U_f = genfromtxt('uf_2', delimiter=',')
U_o = genfromtxt('uo_2', delimiter=',')
WA = []
WI = []
WF = []
WO = []
UA = []
UI = []
UF = []
UO = []

for i in range(0,53):
    Temp_A = np.array([])
    Temp_A = np.append(Temp_A, W_a[i])
    WA.append(Temp_A)

    Temp_I = np.array([])
    Temp_I = np.append(Temp_I, W_i[i])
    WI.append(Temp_I)

    Temp_F = np.array([])
    Temp_F = np.append(Temp_F, W_f[i])
    WF.append(Temp_F)

    Temp_O = np.array([])
    Temp_O = np.append(Temp_O, W_o[i])
    WO.append(Temp_O)

for i in range(0,8):
    Temp_U_A = np.array([])
    Temp_U_A = np.append(Temp_U_A, U_a[i])
    UA.append(Temp_U_A)

    Temp_U_I = np.array([])
    Temp_U_I = np.append(Temp_U_I, U_i[i])
    UI.append(Temp_U_I)

    Temp_U_F = np.array([])
    Temp_U_F = np.append(Temp_U_F, U_f[i])
    UF.append(Temp_U_F)

    Temp_U_O = np.array([])
    Temp_U_O = np.append(Temp_U_O, U_o[i])
    UO.append(Temp_U_O)


U = np.array([UA, UI, UF, UO])
print(U.shape)
# print (U)
print(U[:,0].T)

# W = np.array([WA, WI, WF, WO])

# W_used = W[:,0:1]
# temp = W_used.T
# print (temp.shape)
# print (type(temp))



# w_a =W[0][0]
# w_i =W[1][0]
# w_f =W[2][0]
# w_o =W[3][0]

# W_used = np.concatenate(w_a, w_i, w_f)

# print (W_used.shape)
# print(W.shape)

# print(W[0].shape)

# print(W[0][0])

# print("Wa")

# print(W[1].shape)

# print(W[1])

# print("Wi")

# print(W[2])

# print("Wf")

# print(W[3])

# print("Wo")