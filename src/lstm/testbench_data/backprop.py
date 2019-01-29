def delta_gates(dstate, dout stateprev, currentstate a, i, f, o):
    da = dstate * i* (1-a)**2
    di = dstate*a*i*(1-i)
    df = dstate*stateprev*f*(1-f)
    do = dout* np.tanh(currentstate)*o*(1-o)

    gates = np.append(da, di)
    gates = np.append(gates, df)
    gates = np.append(gates, do)
    return gates

def delta_x (w, gates):
    delta_x_all_cell= np.zeros(53)
    for i in range(0,53):
        W_cell = W[:,i]
        W_cell = W_cell.T
        delta_x_cell = np.dot(W_cell, gates)
        delta_x_all_cell  = delta_x_all_cell + delta_x_cell

    return delta_x_all_Cell

def delta_out_next (u, gates)
    delta_out_next_all_cell=[]
    for i in range(0,53):
        U_cell = U[:,i]
        U_cell = U_cell.T
        delta_out_next_cell = np.dot(U_cell, gates)
        delta_out_next_all_cell  = np.append(delta_out_next_cell, delta_out_next_all_cell)

def delta_state ()
    tanhstate = np.tanh(state)
    dstate = (dout*o*(1- (tanhstate**2)) )  + (dstateprev*f)
    return dstate
    
if __name__ == "__main__":
    import numpy as np
    from numpy import genfromtext

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
        Temp_F = np.append(Temp_F, B_f[i])
        WF.append(Temp_F)

        Temp_O = np.array([])
        Temp_O = np.append(Temp_O, B_o[i])
        WO.append(Temp_O)


    W = np.array([WA, WI, WF, WO])
    # prev_h = np.zeros(53)
    # prev_c = np.zeros(53)

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


