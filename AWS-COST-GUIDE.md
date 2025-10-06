# AWS Cost Optimization Guide for Free Tier

This guide helps you keep your AWS Elastic Beanstalk deployment within free tier limits.

## 💰 Free Tier Limits (12 months from account creation)

### ✅ What's FREE:
- **EC2**: 750 hours/month of t2.micro or t3.micro instances
- **S3**: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- **Data Transfer**: 1GB/month to internet
- **Elastic Beanstalk**: Platform itself is always free

### 💡 Current Configuration (Optimized for Free Tier):

**Single Instance Setup:**
- ✅ **Instance Type**: `t3.micro` (free tier eligible)
- ✅ **Environment Type**: `SingleInstance` (no load balancer charges)
- ✅ **Min/Max Size**: 1 instance only
- ✅ **Health Reporting**: Basic (free)
- ✅ **CloudWatch Logs**: Disabled (to avoid charges)

## 📊 Expected Monthly Costs

### **Within Free Tier Limits:**
- **Elastic Beanstalk**: $0 (always free)
- **EC2 t3.micro**: $0 (free for 750 hours/month)
- **S3 Storage**: $0 (under 5GB)
- **Data Transfer**: $0 (under 1GB/month)
- **Total**: **$0/month** ✅

### **After Free Tier (or if exceeded):**
- **EC2 t3.micro**: ~$8.50/month
- **S3 Storage**: ~$0.10/month  
- **Data Transfer**: ~$0.09/GB
- **Total**: ~$8.70/month

## ⚠️ Things That Can Add Costs

### **Avoid These for Free Tier:**
- ❌ Load balancers (~$16/month)
- ❌ Multiple instances
- ❌ Larger instance types (t3.small, t3.medium, etc.)
- ❌ Enhanced health reporting (~$2/month)
- ❌ CloudWatch detailed monitoring
- ❌ NAT Gateway (~$32/month)

## 🛡️ Cost Monitoring Tips

### **1. Set Up Billing Alerts:**
```
AWS Console → Billing → Billing preferences → Enable:
- Receive PDF Invoice By Email
- Receive Free Tier Usage Alerts
- Receive Billing Alerts
```

### **2. Monitor Free Tier Usage:**
```
AWS Console → Billing → Free Tier
Check your usage regularly
```

### **3. Set Budget Alerts:**
```
AWS Console → Billing → Budgets → Create budget
Set alert for $1 threshold
```

## 🚀 Scaling Options (When Ready to Pay)

### **Production Ready Setup:**
- **Load Balanced Environment** with auto-scaling
- **Multiple Availability Zones**
- **Enhanced Health Reporting**
- **SSL Certificate** (free with AWS Certificate Manager)
- **CloudWatch Monitoring**

### **Estimated Cost**: $25-50/month depending on traffic

## 🔧 How to Modify Configuration

### **To Use Load Balancer (Production):**
Edit `.ebextensions/01-app-config.config`:
```yaml
aws:elasticbeanstalk:environment:
  EnvironmentType: LoadBalanced  # Change from SingleInstance
```

### **To Scale Up:**
```yaml
aws:autoscaling:asg:
  MinSize: "2"
  MaxSize: "4"
```

### **To Use Larger Instances:**
```yaml
aws:autoscaling:launchconfiguration:
  InstanceType: t3.small  # Or t3.medium
```

## 💡 Development vs Production

### **Current Setup (Free Tier):**
- ✅ Perfect for **learning and development**
- ✅ Can handle **low to moderate traffic**
- ✅ No high availability (single instance)

### **When to Upgrade:**
- Need **high availability**
- Expect **high traffic**
- Require **SSL/HTTPS**
- Need **auto-scaling**

## 🎯 Summary

Your current configuration is optimized for the AWS Free Tier and should cost **$0/month** for the first 12 months (or until you exceed free tier limits). This is perfect for learning CI/CD with AWS!