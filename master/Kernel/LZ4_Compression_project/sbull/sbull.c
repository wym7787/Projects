/*
 * Sample disk driver, from the beginning.
 */

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/init.h>

#include <linux/sched.h>
#include <linux/kernel.h>	/* printk() */
#include <linux/slab.h>		/* kmalloc() */
#include <linux/fs.h>		/* everything... */
#include <linux/errno.h>	/* error codes */
#include <linux/timer.h>
#include <linux/types.h>	/* size_t */
#include <linux/fcntl.h>	/* O_ACCMODE */
#include <linux/hdreg.h>	/* HDIO_GETGEO */
#include <linux/kdev_t.h>
#include <linux/vmalloc.h>
#include <linux/genhd.h>
#include <linux/blkdev.h>
#include <linux/buffer_head.h>	/* invalidate_bdev */
#include <linux/bio.h>
#include <linux/lz4.h>
#include <linux/list.h>
#include <linux/delay.h>

MODULE_LICENSE("Dual BSD/GPL");

static int sbull_major = 0;
static int hardsect_size = 512;
static int nsectors = 1024 * 1024;	/* How big the drive is */
static int ndevices = 1;
static int b_size = 4096;
static int total_device;
static char *mem_buf;

struct info{
	unsigned long real_file;
	unsigned long com_file;
	unsigned long write_count;
	unsigned long read_count;
};

struct info *state;


int max_out_size;

static int *arr;

int encryptmode;
int input_key;
int key;


/*
 * Minor number and partition management.
 */

#define SBULL_MINORS	16
#define MINOR_SHIFT	4
#define DEVNUM(kdevnum)	(MINOR(kdev_t_to_nr(kdevnum)) >> MINOR_SHIFT

/*
 * We can tweak our hardware sector size, but the kernel talks to us
 * in terms of small sectors, always.
 */
#define KERNEL_SECTOR_SIZE	512
/*
 * After this much idle time, the driver will simulate a media change.
 */
#define INVALIDATE_DELAY	30*HZ

/*
 * The internal representation of our device.
 */
struct sbull_dev {
    /* TODO : Write your codes */
	int size;
	int users;
	char *data;
	spinlock_t lock;
	struct request_queue *queue;
	struct gendisk *gd;
};

static struct sbull_dev *Devices = NULL;

/*
 * Handle an I/O request.
 */
static void sbull_transfer(struct sbull_dev *dev, unsigned long sector,
		unsigned long nsect, char *buffer, int write)
{
    /* TODO : Write your codes */
	unsigned long offset = sector*KERNEL_SECTOR_SIZE;
	unsigned long nbytes = nsect*KERNEL_SECTOR_SIZE;
	//int i;
	int c_size = 0;
	int d_size = 0;
	int c_offset = 0;
	int d_offset = 0;
	if((offset + nbytes) > dev->size){
		printk(KERN_NOTICE "Beyond-end write (%ld %ld)\n",offset, nbytes);
		return ;
	}
	if(write)
	{
		//No compressed write(Basic setting)
		/*			
		c_offset = offset / b_size;
		arr[c_offset] = 1;
		state->real_file += nbytes;
		state->write_count++;	
		memcpy(dev->data + offset, buffer, nbytes);
		*/
		//compressed data using LZ4	
		
		c_offset = offset / b_size;	
		c_size = LZ4_compress_default(buffer, dev->data + offset, nbytes, max_out_size, (void *)mem_buf);	
		arr[c_offset] = c_size;
		state->real_file += nbytes;
		state->com_file += c_size;		
		state->write_count++;
		
		
	}
	else
	{
		//No compressed read
		/*
		d_offset = offset / b_size;
		if(arr[d_offset] != -1)
		{
			state->real_file += nbytes;
			state->read_count++;
		}
		memcpy(buffer, dev->data + offset, nbytes);
		*/
	
		//Compressed data using LZ4
		
		d_offset = offset / b_size;
		d_size = LZ4_decompress_safe(dev->data + offset, buffer, arr[d_offset], b_size);
		if(arr[d_offset] != -1)
		{
			state->real_file += nbytes;
			state->com_file += arr[d_offset];
			state->read_count++;
		}
		
				
	}
	return ;

}


/*
 * Transfer a single BIO.
 */
static int sbull_xfer_bio(struct sbull_dev *dev, struct bio *bio)
{
    /* TODO : Write your codes */
    struct bio_vec bvec;
    struct bvec_iter iter;
    sector_t sector = bio->bi_iter.bi_sector;

    bio_for_each_segment(bvec, bio, iter)
    {
	char *buffer = __bio_kmap_atomic(bio,iter);
    sbull_transfer(dev, sector, bio_cur_bytes(bio) >> 9,
				buffer, bio_data_dir(bio) == WRITE);
    sector += bio_cur_bytes(bio) >> 9;
    __bio_kunmap_atomic(bio);
    }

	return 0; /* Always "succeed" */
}


/*
 * The direct make request version.
 */
static void sbull_make_request(struct request_queue *q, struct bio *bio)
{
	struct sbull_dev *dev = q->queuedata;
	int status;

	status = sbull_xfer_bio(dev, bio);
	bio_endio(bio);
}


/*
 * Open and clos:e.
 */
/* changed open and release function */

static int sbull_open(struct block_device *bdev, fmode_t mode)
{
	
    struct sbull_dev *dev = bdev->bd_disk->private_data;
    /* file->private_data = dev is deleted*/
    /* TODO : Write your codes */
    spin_lock(&dev->lock);
    if(!dev->users){
    }
    dev->users++;
    spin_unlock(&dev->lock);
    state->real_file = 0;
    state->com_file = 0;
    //    printk("sbull_open!\n");
    return 0;
}

static void sbull_release(struct gendisk *disk, fmode_t mode)
{
	struct sbull_dev *dev = disk->private_data;
        spin_lock(&dev->lock);
        dev->users--;
        if(!dev->users){
	}
	spin_unlock(&dev->lock);

/*	
	printk(KERN_INFO "User capacity : %ldMB\n",state->real_file / nsectors );
	printk(KERN_INFO "Storaged Capacity : %ldMB\n",state->com_file / nsectors);
	printk(KERN_INFO "Write_count = %ld\n",state->write_count);
	printk(KERN_INFO "Read_count  = %ld\n",state->read_count);
*/	
	return ;


}

/*
 * The ioctl() implementation
 */

int sbull_ioctl (struct block_device *bdev, fmode_t mode,
                 unsigned int cmd, unsigned long arg)
{
    /* TODO : Write your codes */
    int ret = 0;
	
	switch(cmd)
	{
		case 0:
		copy_to_user((void *)arg, (void *)state, sizeof(struct info));
		state->com_file = 0;
		state->real_file = 0;
		state->read_count = 0;
		state->write_count = 0;
		memset(arr,-1, sizeof(int) * (total_device / b_size));
		break;		
	}
	
    return ret; /* unknown command */
}



/*
 * The device operations structure.
 */
static struct block_device_operations sbull_ops = {
    /* TODO : Write your codes */
	.owner = THIS_MODULE,
	.open = sbull_open,
	.release = sbull_release,
	.ioctl = sbull_ioctl
};


/*
 * Set up our internal device.
 */
static void setup_device(struct sbull_dev *dev, int which)
{
    /* TODO : Write your codes */
    /*
     * Get some memory.
     */
    memset(dev,0,sizeof(struct sbull_dev));
    dev->size = nsectors*hardsect_size*2;
    dev->data = vmalloc(dev->size);
    total_device = dev->size;
//    printk(KERN_INFO "arr_size = %d\n",dev->size / b_size);
   
    arr = (int *)vmalloc(sizeof(int) * dev->size / b_size);
    memset(arr, -1, sizeof(int) * dev->size / b_size); 
    mem_buf = (char *)vmalloc(sizeof(char) * LZ4_MEM_COMPRESS);
    max_out_size = LZ4_compressBound(b_size);
    state = (struct info *)vmalloc(sizeof(struct info));
    memset(state, 0, sizeof(struct info));


//   printk(KERN_INFO "max_out_size = %d\n",max_out_size);
    if(dev->data == NULL){
	printk(KERN_NOTICE "vmalloc failure\n");
	return ;
    }
    spin_lock_init(&dev->lock);   
    /*
     * The I/O queue, depending on whether we are using our own
     * make_request function or not.
     */
    dev->queue = blk_alloc_queue(GFP_KERNEL);
    if (dev->queue == NULL)
        goto out_vfree;
    blk_queue_logical_block_size(dev->queue, KERNEL_SECTOR_SIZE);

    blk_queue_make_request(dev->queue, (make_request_fn *)sbull_make_request);		
    dev->queue->queuedata = dev;

    dev->gd = alloc_disk(SBULL_MINORS);
    if(!dev->gd){
	printk(KERN_NOTICE "alloc_disk failure\n");
	goto out_vfree;
    }

    dev->gd->major = sbull_major;
   
    dev->gd->first_minor = which*SBULL_MINORS;
    dev->gd->fops = &sbull_ops;
    dev->gd->queue = dev->queue;
    dev->gd->private_data = dev;
    snprintf(dev->gd->disk_name,32,"sbull%c",which + 'a');
    set_capacity(dev->gd,2*nsectors*(hardsect_size/KERNEL_SECTOR_SIZE));
    add_disk(dev->gd);
    /*
     * And the gendisk structure.
     */
    
    return;

out_vfree:
    if (dev->data)
        vfree(dev->data);
}



static int __init sbull_init(void)
{
	int i;
	/*
	 * Get registered.
	 */
	sbull_major = register_blkdev(sbull_major, "sbull");
	if (sbull_major <= 0) {
		printk(KERN_WARNING "sbull: unable to get major number\n");
		return -EBUSY;
	}
	/*
	 * Allocate the device array, and initialize each one.
	 */
	Devices = kmalloc(ndevices * sizeof (struct sbull_dev), GFP_KERNEL);
	if (Devices == NULL)
		goto out_unregister;
	for (i = 0; i < ndevices; i++) 
		setup_device(Devices + i, i);

    return 0;

  out_unregister:
	unregister_blkdev(sbull_major, "sbd");
	return -ENOMEM;
}

static void sbull_exit(void)
{
	int i;

	for (i = 0; i < ndevices; i++) {
		struct sbull_dev *dev = Devices + i;

		if (dev->gd) {
			del_gendisk(dev->gd);
			put_disk(dev->gd);
		}
		if (dev->queue) {
				kobject_put (&dev->queue->kobj);
		}
		if (dev->data)
			vfree(dev->data);
	}
	unregister_blkdev(sbull_major, "sbull");
	vfree(mem_buf);
	vfree(arr);
	vfree(state);
	kfree(Devices);
}
	
module_init(sbull_init);
module_exit(sbull_exit);
