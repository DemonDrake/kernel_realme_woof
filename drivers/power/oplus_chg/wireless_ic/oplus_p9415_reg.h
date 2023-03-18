#ifndef __OPLUS_P9415_REG_H__
#define __OPLUS_P9415_REG_H__

#define P9415_RX_PWR_15W		0x1e
#define P9415_RX_PWR_10W		0x14
#define P9415_RX_MODE_EPP		0x31
#define P9415_RX_MODE_BPP		0x04

#define P9415_REG_VOUT_R		0x003c
#define P9415_REG_VOUT_W		0x003e
#define P9415_REG_VRECT			0x0040
#define P9415_REG_TOUT			0x0044
#define P9415_REG_TRX_VOL		0x0070
#define P9415_REG_TRX_CURR		0x006e
#define P9415_REG_CEP_COUNT		0x0020
#define P9415_REG_CEP			0x0033
#define P9415_REG_FREQ			0x005e
#define P9415_REG_RX_MODE		0x0088
#define P9415_REG_RX_PWR		0x0084
#define P9415_REG_TRX_STATUS		0x0078
#define P9415_REG_TRX_ERR		0x0079
#define P9415_REG_HEADROOM_R		0x009e
#define P9415_REG_HEADROOM_W		0x0076
#define P9415_REG_FOD			0x0068

#define P9415_REG_PWR_CTRL		0x00d0
#define P9415_DCDC_EN			BIT(0)

#define P9415_REG_TRX_CTRL		0x0076
#define P9415_TRX_EN			BIT(0)

#define P9415_REG_STATUS		0x0036
#define P9415_VOUT_ERR			BIT(3)
#define P9415_EVENT			BIT(4)
#define P9415_TRX_EVENT			BIT(5)
#define P9415_LDO_ON			BIT(6)

#define P9415_TRX_STATUS_READY		BIT(0)
#define P9415_TRX_STATUS_DIGITALPING	BIT(1)
#define P9415_TRX_STATUS_ANALOGPING	BIT(2)
#define P9415_TRX_STATUS_TRANSFER	BIT(3)

#define P9415_TRX_ERR_RXAC		BIT(0)
#define P9415_TRX_ERR_OCP		BIT(1)
#define P9415_TRX_ERR_OVP		BIT(2)
#define P9415_TRX_ERR_LVP		BIT(3)
#define P9415_TRX_ERR_FOD		BIT(4)
#define P9415_TRX_ERR_OTP		BIT(5)
#define P9415_TRX_ERR_CEPTIMEOUT	BIT(6)
#define P9415_TRX_ERR_RXEPT		BIT(7)


#define P9415_MTP_VOL_MV		5500
#define P9415_TRX_VOL_MV		5500

#endif /* __OPLUS_P9415_REG_H__ */