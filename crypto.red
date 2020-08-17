Red/System []

comment {
	用 Red/System 对系统加解密库的封装。各平台使用的底层库如下：
	
	* Windows：CNG
	* Linux：libcrypto (OpenSSL) 
	* macOS: libcrypto (OpenSSL) installed by homebrew

	由于只是对底层库的封装，而且CNG和libcrypto的API大同小异。所以R/S的API应
	接近其中一个底层库。这样在其中一个平台可以很容易实现。平台的API有差别时，
	选择容易使用的一个。比如Symmetric Algorithms的API，选择了接近libcrypto的
	设计。
}

#enum crypt-algorithm! [
	AES
	DES
	_3DES
	RC4
]

#enum block-chaining! [
	ECB
	CBC
	;CFB8
	;CFB64
	;CFB128
	GCM
	CCM
	;GMAC
	;CMAC
]

cipher: context [

	verbose: 0
	#define DPrint(msg) [#if debug? = yes [if verbose > 0 [print-line msg]]]

#either OS = 'Windows [

	#import [
		
	]
	;== Symmetric Algorithms

	make: func [return: [handle!]][]

	reset: func [hCrypt [handle!] return: [integer!]][]

	free: func [hCrypt [handle!]][]

	encypt-init: func [
		hCrypt		[handle!]
		alg			[crypt-algorithm!]
		IV			[byte-ptr!]			;-- initialization vector
		key			[byte-ptr!]
		key-len		[uint!]				;-- AES: 128, 192 or 256, DES: 56, 3DES: 56, 112, 168
		chain-mode	[block-chaining!]	;-- CBC, ECB, GCM, etc
		return:		[integer!]			;-- error code
	][
		DPrint("encypt-init")
	]

	encypt-update: func [
		hCrypt		[handle!]			;-- handle returned by make
		data		[byte-ptr!]
		data-len	[uint!]
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]			;-- error code
	][]

	encrypt-final: func [
		hCrypt		[handle!]			;-- handle returned by make
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]
	][]

	decrypt-init: func [
		hCrypt		[handle!]
		alg			[crypt-algorithm!]
		IV			[byte-ptr!]			;-- initialization vector
		key			[byte-ptr!]
		key-len		[uint!]				;-- AES: 128, 192 or 256, DES: 56, 3DES: 56, 112, 168
		chain-mode	[block-chaining!]	;-- CBC, ECB, GCM, etc
		return:		[integer!]			;-- error code
	][]

	decrypt-update: func [
		hCrypt		[handle!]			;-- handle returned by make
		data		[byte-ptr!]
		data-len	[uint!]
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]			;-- error code
	][]

	decrypt-final: func [
		hCrypt		[handle!]			;-- handle returned by make
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]
	][]

	set-property: func [				;-- set IV length, tag length, etc.
		hCrypt		[handle!]			;-- handle returned by make
		property	[integer!]
		input		[byte-ptr!]
		input-len	[integer!]
		return:		[integer!]
	]

	get-property: func [
		hCrypt		[handle!]			;-- handle returned by make
		property	[integer!]
		output		[byte-ptr!]
		output-len	[int-ptr!]
		return:		[integer!]	
	]

	;== Asymmetric Algorithms
	rsa-make: 

	;== Key Exchange Algorithms
	;-- ECDH, ECDSA, etc

	;== Hashing Algorithms
	;-- SHA, MD5, etc
	
][ ;@@ #either Linux & macOS use OpenSSL
	#switch OS [
		macOS [
			#define LIBCRYPTO-file "libcrypto.dylib"
		]
		FreeBSD [
			#define LIBCRYPTO-file "libcrypto.so.8"
		]
		#default [
			#switch config-name [
				RPi		  [#define LIBCRYPTO-file "libcrypto.so.1.1"]
				Linux-ARM [#define LIBCRYPTO-file "libcrypto.so.1.1"]
				#default  [#define LIBCRYPTO-file "libcrypto.so.1.0.2"]
			]
		]
	]

	#import [
		LIBCRYPTO-file cdecl [
		]
	]

	;== Symmetric Algorithms

	make: func [return: [handle!]][]
	
	reset: func [hCrypt [handle!] return: [integer!]][]
	
	free: func [hCrypt [handle!]][]

	encypt-init: func [
		hCrypt		[handle!]
		alg			[crypt-algorithm!]
		IV			[byte-ptr!]			;-- initialization vector
		key			[byte-ptr!]
		key-len		[uint!]				;-- AES: 128, 192 or 256, DES: 56, 3DES: 56, 112, 168
		chain-mode	[block-chaining!]	;-- CBC, ECB, GCM, etc
		return:		[integer!]			;-- error code
	][
		DPrint("encypt-init")
	]

	encypt-update: func [
		hCrypt		[handle!]			;-- handle returned by make
		data		[byte-ptr!]
		data-len	[uint!]
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]			;-- error code
	][]

	encrypt-final: func [
		hCrypt		[handle!]			;-- handle returned by make
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]
	][]

	decrypt-init: func [
		hCrypt		[handle!]
		alg			[crypt-algorithm!]
		IV			[byte-ptr!]			;-- initialization vector
		key			[byte-ptr!]
		key-len		[uint!]				;-- AES: 128, 192 or 256, DES: 56, 3DES: 56, 112, 168
		chain-mode	[block-chaining!]	;-- CBC, ECB, GCM, etc
		return:		[integer!]			;-- error code
	][]

	decrypt-update: func [
		hCrypt		[handle!]			;-- handle returned by make
		data		[byte-ptr!]
		data-len	[uint!]
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]			;-- error code
	][]

	decrypt-final: func [
		hCrypt		[handle!]			;-- handle returned by make
		outbuf		[byte-ptr!]
		outlen		[int-ptr!]
		return:		[integer!]
	][]

	set-property: func [				;-- set IV length, tag length, etc.
		hCrypt		[handle!]			;-- handle returned by make
		property	[integer!]
		input		[byte-ptr!]
		input-len	[integer!]
		return:		[integer!]
	]

	get-property: func [
		hCrypt		[handle!]			;-- handle returned by make
		property	[integer!]
		output		[byte-ptr!]
		output-len	[int-ptr!]
		return:		[integer!]	
	]

	;== Asymmetric Algorithms
	;-- RSA

	;-- DSA

	;== Key Exchange Algorithms
	;-- ECDH, ECDSA, etc

	;== Hashing Algorithms
	;-- SHA, MD5, etc	
	
]]
